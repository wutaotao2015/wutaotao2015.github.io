#!/bin/bash
# execute this shell in post dir

echo "begin merge..."
now=$(date +"%T:%N")
#echo "choose mode:"
#echo "1: merge little md files."
#echo "2: split one big md file."
#read mode

#if [ ${mode}=1 ]; then
 # 3 little md files
 cat "$@" > ~/Downloads/taoblog${now}.md

 cd ~/Downloads/
 sed -i 's#<img src=".*"\s*/>##g' taoblog${now}.md
 sed -i 's#!\[.*\](.*)##g' taoblog${now}.md
 sed -i 's@<hr\s*/>@@g' taoblog${now}.md
 sed -i 's@---@```@g' taoblog${now}.md
 sed -i 's@<!--\s*more\s*-->@@g' taoblog${now}.md
 #sed -i 's@\(```\ntitle:\(.*\)\)@#\2\r\1@g' taoblog${now}.md
 perl -0777 -pi -e 's@(```\ntitle:(.*))@#$2\n$1@g' taoblog${now}.md 
 # at last add toc at head
 sed -i '1s@^@[toc]\n\n@' taoblog${now}.md

#else 
#  if [ ${mode}=2 ]; then
#   cp $1 ~/Downloads/taoblog.md
#
#   cd ~/Downloads/
#   sed -i 's#<img src=".*"\s*/>##g' taoblog.md
#   sed -i 's#!\[.*\](.*)##g' taoblog.md
#
#   if [ $2 ]; then
#     split -l $2 taoblog.md --additional-suffix .md
#   fi
#  fi
#fi

#typora &
echo "done merge"

