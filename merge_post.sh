#!/bin/bash

cd ./source/_posts

../../toolForMerge.sh 01182019-First.md 01202019-DomainName.md 03152019-PersonalThought.md 04142019-MacOS_ReInstallNote.md 01222019-Markdown_Basic_Rule.md 02272019-Mysql_8.0_Install_Guidance.md 02232019-HerokuNote.md
../../toolForMerge.sh 03042019-DataStructureDesignNote.md 05102019-LinuxNote.md 01302019-SpringCloud_Note.md 03072019-Mybatis_Note.md 01222019-Hexo_Blog_Guidance.md 
../../toolForMerge.sh 03012019-IntelliJ_Idea_Note.md 02112019-ToolTips.md 
../../toolForMerge.sh 05122019-Java1_Core10Note.md
../../toolForMerge.sh 09172019-Java2_Core10Note.md
../../toolForMerge.sh 09172019-Java3-Core10Note.md

echo "all md file merge done"
