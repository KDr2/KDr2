#lang scribble/manual

@(require "../../src/main.rkt")

@title[#:style favicon]{Exporting and Restoring data from ApacheDS}


@(define ads (hyperlink "http://directory.apache.org/apacheds/" "ApacheDS"))
@(define adstudio (hyperlink "https://directory.apache.org/studio/" "Apache Directory Studio"))


[2018-12-25]

I am using @ads as the LDAP server and find I should export the data
out from it or restore the exported data into it under some
circumstances:

@itemlist[

@item{When the data is corrupted thus while we are able to read the
data but we can't write new data into it.}

@item{When we want to back up the data and possibly restore it in the
future.}

]

Though @ads provides a desktop application based on Eclipse RCP, the
@adstudio, to manage the @ads server and the data in it, it doesn't
provide a tool to do this automatically. So we could resort to the
commands in the @icode{ldap-utils} package. This package offers many
commands to interact with a LDAP server, includes:

@itemlist[

@item{ldapadd}
@item{ldapcompare}
@item{ldapdelete}
@item{ldapexop}
@item{ldapmodify}
@item{ldapmodrdn}
@item{ldappasswd}
@item{ldapsearch}
@item{ldapurl}
@item{ldapwhoami}

]

To resolve our problems, we can use @icode{ldapsearch} to export the data,
and @icode{ldapadd} to restore the data.

To export the data, it is quite straightforward:

@cblock{

  ldapsearch -LLL -h localhost -p 10389\
             -D "uid=admin,ou=system" -w secrete \
             -b "dc=example,dc=com" -s sub "(ObjectClass=*)" >data.ldif
}

With @icode{-LLL} we tell @icode{ldapsearch} to display data in the
LDIF(LDAP Data Interchange Format) format, then we give the host and
port of the server, the bind DN and the password of the user, the
search base and the search scope, and finally an attribute filter
which will match all the nodes to the command. To store the exported
data, we redirect the stdout of the command to a file at the end of
the command.

The data is now successfully exported, but before talking about how to
restore it, let's recall what we did while setting up the @ads server:

@itemlist[#:style 'ordered

@item{Download it, unzip it, start it.}

@item{Create a partition, using @adstudio is the easiest way to do
it.}

@item{Restart the server to make the new partition ready.}

@item{Update the system settings of the server if needed.}

@item{Create our own schema(commonly, attribute types and object
classes).}

]

Before restoring the exported data, we should set up a new server
instance by these steps first. Then we can do the restoring using
@icode{ladpadd} like this:

@cblock{
  ldapadd -h 127.0.0.1 -p 10389 \
          -D "uid=admin,ou=system" -w secret \
          -f /path/to/data.ldif -c
}

But many errors will be encountered while running this command. Inside
the @ads server, the data is organized as trees. So a parent node must
be specified while creating a new node. This requires that the parent
node of a certain node must have been restored while it is going to be
restored. On the other hand, the command @icode{ldapadd} adds new nodes
in the order of how the nodes are stored in the LDIF file, and the
parent-fist order is not guaranteed by @icode{ldapsearch}. So errors
happen when @icode{ldapadd} creates nodes whose parent are not created
yet.

There are two ways to resolve this problem:

The first one is crude: We run the @icode{ldapadd} command multiple
times with the option @icode{-c}.

The @icode{-c} option makes @icode{ldapadd} run in a continuous
operation mode, when an error occurs, @icode{ldapadd} reports the error
and goes on with its work instead of exiting. Here the errors include
ones like "parent node does not exist", "node already exists", and
many other kinds of errors.

The count of the times is determined by the maximum depth of the data
tree in the @ads server. For example, if our data has a max-depth
3, we should run the command 3 times. During the first time, all nodes
with depth 1 and a few other nodes will be restored. Then the node
with depth 2 and then 3. Finally, all the nodes will be restored.

The second one is a little more elegant than the first one, but still
simple: we first sort the exported data, then import it. Here is a
perl script to sort the data in the LDIF file:

@cblock|{
  #!/usr/bin/env perl

  use v5.12;
  use MIME::Base64;

  my $all_nodes = {};
  my $all_dn =[];
  my $current_node = "";
  my $current_dn = "";
  my $dn_just_assigned = 0;

  while(<>) {
      $current_node .= $_;
      if(m/^\s+$/) {
          $all_nodes->{$current_dn} = $current_node;
          push @$all_dn, $current_dn;
          $current_node = "";
          $current_dn = "";
          next;
      }
      if(m/^dn::?\s(.*)$/) {
          $current_dn = $1;
          $dn_just_assigned = 1;
          next;
      }
      if($dn_just_assigned) {
          $current_dn .= $1 if(m/^\s+(.+)/);
          $current_dn = decode_base64($current_dn) if index($current_dn, ",") < 0;
          $dn_just_assigned = 0;
      }
  }

  $all_dn = [sort {length $a <=> length $b} @$all_dn];
  print $all_nodes->{$_} foreach(@$all_dn);

}|

Save it as @icode{ldap-data-sorter.pl} and run it:

@cblock{
ldap-data-sorter.pl /path/to/data.ldif > data-sorted.ldif
}

Then restore the data by running the below command for only once:

@cblock{
  ldapadd -h 127.0.0.1 -p 10389 \
          -D "uid=admin,ou=system" -w secret \
          -f /path/to/data-sorted.ldif -c
}

If all goes well, you will have got what you want at this point.

Good luck with @ads and @adstudio .
