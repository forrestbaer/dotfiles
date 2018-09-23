set realname="Forrest Baer"
set from="public@forrestbaer.com"

set imap_user="bills@forrestbaer.com"
#set imap_pass to the fastmail app-specific password

set folder="imaps://imap.fastmail.com:993"
set spoolfile="imaps://imap.fastmail.com/INBOX"

set record="+Sent"
set postponed="+Drafts"
set mbox="+Archive"

set read_inc=1000
set write_inc=1000
set mail_check=5

mailboxes ! =INBOX/art =INBOX/bills =INBOX/gmail =INBOX/private =INBOX/public =INBOX/save =INBOX/work =Sent =Drafts =Archive =Spam
