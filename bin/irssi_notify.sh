# yes, we need a way to flush the file on disconnect; i don't know one
ssh $1 "tail -n 10 $HOME/.irssi/fnotify; > $HOME/.irssi/fnotify; tail -f $HOME/.irssi/fnotify" |
#	sed -u 's/[<@&]//g' |
	sed -ru "
		s/&/\&amp;/g;
		s/</\&lt;/g;
		s/>/\&gt;/g;
		s%(#[a-zA-Z]+ )&lt;([^>]{0,10})&gt;%\1<b>\2</b> %g
		s%(https?://[^ ]+\.[a-zA-Z]{1,3})%<a href=\"\1\">\1</a>%g;
		s%([a-zA-Z0-9+_-]+@[^ ]+\.[a-zA-Z]{1,3})%<a href=\"mailto:\1\">\1</a>%g;" |
	while read heading message
	do
		notify-send -i gtk-dialog-info -t 300000 -- "${heading}" "${message}"
	done
# the sed -u 's/[<@&]//g' is needed as those characters might confuse  notify-send (FIXME: is that a bug or a feature?)
