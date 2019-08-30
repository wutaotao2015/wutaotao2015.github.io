#!/bin/bash

# need to input post files directory path, like /home/tao/wtt/blog/source/_posts
fileNames=""
for file in "$1"/*; do
  fileNames="${fileNames} ${file}"
done
echo ${fileNames}

pandoc -o ~/Downloads/taoblog.epub ./pandocTitle.txt ${fileNames} --toc
echo "epub generated!"
