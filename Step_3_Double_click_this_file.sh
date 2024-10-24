#!/bin/bash

#Note 1: Here's how to do this without exiftool    https://www.youtube.com/watch?v=b33ir6FZMlY
#Note 2: Use    ../Step_1_Dont_modify_this_folder/exiftool -s -time:all <file name here>    to see what time stamps are available for that file
#Note 3: exiftool common commands    https://github.com/jonkeren/Exiftool-Commands
#Note 4: exiftool all tag names    https://exiftool.org/TagNames/
#Note 5: "everything You Ever Wanted to Know about ExifTool"    https://adamtheautomator.com/exiftool/
#Note 6: To prevent accidents I originally hid all but the    META.json    file in the    Step_1_Dont_modify_this_folder    folder by setting    chflags hidden    to each of the files from terminal but decided that could eventually become confusing so changed them all back with    chflags nohidden

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd "${DIR}/Step_2_Drop_your_photos_and_videos_in_here"

REGEX1='-{3}'
REGEX2='_{2}'

echo
echo "Make a selection: "
choices=("Show me EXIF data of a file in the folder" "Change a file name in the folder" "Revert back a file name that changed in the folder" "Change ALL the file names in the folder" "Revert back ALL the file names that changed in the folder" "Quit") #add options to rename a chosen file name, and to revert a chosen filename back to original
select SELECTION_01 in "${choices[@]}"



do
    case $SELECTION_01 in
        "Show me EXIF data of a file in the folder")
            echo
            echo "You chose '$REPLY' and want to see the EXIF data of a file in the folder."
            echo
            echo "Here are the files:"
            ls
            echo
            echo "Copy and paste the name of a file from the list above to see it's EXIF data"

            read SELECTION_02

            ../Step_1_Dont_modify_this_folder/exiftool $SELECTION_02

            break
            ;;
        "Change a file name in the folder")
            echo
            echo "You chose '$REPLY' and want to change a file name in the folder."
            echo
            echo "Here are the files:"
            ls
            echo
            echo "Copy and paste the name of a file from the list above to change its name."

            read SELECTION_03

            ../Step_1_Dont_modify_this_folder/exiftool -if '$filetype eq "MOV"' -d '%Y-%m-%d---%H.%M.%S__%%f%%-c.%%e' '-filename<CreationDate' $SELECTION_03

            ../Step_1_Dont_modify_this_folder/exiftool -if '$filetype eq "MOV"' -if '$CreateDate eq "0000:00:00 00:00:00"' -d '%Y-%m-%d---%H.%M.%S__%%f%%-c.%%e' '-filename<FileModifyDate' $SELECTION_03

            ../Step_1_Dont_modify_this_folder/exiftool -if '$filetype eq "MP4"' -if '$HandlerVendorID eq "Apple"' -d '%Y-%m-%d---%H.%M.%S__%%f%%-c.%%e' '-filename<CreateDate' $SELECTION_03

            ../Step_1_Dont_modify_this_folder/exiftool -if '$filetype eq "JPEG"' -d '%Y-%m-%d---%H.%M.%S__%%f%%-c.%%e' '-filename<DateTimeOriginal' $SELECTION_03

            ../Step_1_Dont_modify_this_folder/exiftool -if '$filetype eq "PNG"' -d '%Y-%m-%d---%H.%M.%S__%%f%%-c.%%e' '-filename<FileModifyDate' $SELECTION_03

            ../Step_1_Dont_modify_this_folder/exiftool -if '$filetype eq "HEIC"' -d '%Y-%m-%d---%H.%M.%S__%%f%%-c.%%e' '-filename<FileModifyDate' $SELECTION_03            

            break
            ;;
        "Revert back a file name that changed in the folder")
            echo
            echo "You chose '$REPLY' and want to revert back a file name that changed in the folder."
            echo
            echo "Here are the files:"
            ls
            echo
            echo "Copy and paste the name of a file from the list above to change its name."

            read SELECTION_04

                if [[ "$SELECTION_04" =~ $REGEX1 && "$SELECTION_04" =~ $REGEX2 ]]
                then
                    mv "$SELECTION_04" "${SELECTION_04:23}";
                fi

            break
            ;;

        "Change ALL the file names in the folder")
            echo
            echo "You chose '$REPLY' and want to change ALL the file names in the folder"

            ../Step_1_Dont_modify_this_folder/exiftool -if '$filetype eq "MOV"' -d '%Y-%m-%d---%H.%M.%S__%%f%%-c.%%e' '-filename<CreationDate' *

            ../Step_1_Dont_modify_this_folder/exiftool -if '$filetype eq "MOV"' -if '$CreateDate eq "0000:00:00 00:00:00"' -d '%Y-%m-%d---%H.%M.%S__%%f%%-c.%%e' '-filename<FileModifyDate' *

            ../Step_1_Dont_modify_this_folder/exiftool -if '$filetype eq "MP4"' -if '$HandlerVendorID eq "Apple"' -d '%Y-%m-%d---%H.%M.%S__%%f%%-c.%%e' '-filename<CreateDate' *

            ../Step_1_Dont_modify_this_folder/exiftool -if '$filetype eq "JPEG"' -d '%Y-%m-%d---%H.%M.%S__%%f%%-c.%%e' '-filename<DateTimeOriginal' *

            ../Step_1_Dont_modify_this_folder/exiftool -if '$filetype eq "PNG"' -d '%Y-%m-%d---%H.%M.%S__%%f%%-c.%%e' '-filename<FileModifyDate' *

            ../Step_1_Dont_modify_this_folder/exiftool -if '$filetype eq "HEIC"' -d '%Y-%m-%d---%H.%M.%S__%%f%%-c.%%e' '-filename<FileModifyDate' *

            break
            ;;
        "Revert back ALL the file names that changed in the folder")
            echo
            echo "You chose '$REPLY' want to revert back ALL the file names back in the folder"
            echo
            for f in *
                do
                    if [[ "$f" =~ $REGEX1 && "$f" =~ $REGEX2 ]]
                    then
                        mv "$f" "${f:23}";
                    fi
                done

            break
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac

done


if [[ "$SELECTION_01" != "Show me EXIF data of a file in the folder" ]]
then
    killall 'Terminal'
else
    exit 0
fi
