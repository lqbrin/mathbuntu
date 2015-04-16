renewDocumentationMd5sums()
{
  docList=( $(cat $1 | grep -v -E "^#") )
  newfile=$1.new
  numDocs=$(( ${#docList[@]} / 8 ))
  echo "######################################################" > $newfile
  echo "# DOCUMENTATION: 8 lines per document:               #" >> $newfile
  echo "# 0) General information URL                         #" >> $newfile
  echo "# 1) pdf download URL                                #" >> $newfile
  echo "# 2) license URL                                     #" >> $newfile
  echo "# 3) license icon                                    #" >> $newfile
  echo "# 4) source filename                                 #" >> $newfile
  echo "# 5) destination filename                            #" >> $newfile
  echo "# 6) Brief Title (in HTML, no spaces)                #" >> $newfile
  echo "# 7) md5sum                                          #" >> $newfile
  echo "######################################################" >> $newfile
  echo "#" >> $newfile
  echo "# Last updated $day" >> $newfile
  for (( i = 0 ; i < $numDocs ; i++ )) do
    echo "#" >> $newfile
    echo "#" >> $newfile
    downloadURL=${docList[8*i+1]}
    sourceName=${docList[8*i+4]}
    echo "aria2c -d /tmp $downloadURL"
    aria2c -d /tmp $downloadURL
    newMd5=`md5sum "/tmp/$sourceName" | awk -F'  ' '{print $1}'`
    oldMd5=${docList[8*i+7]}
    if [ "$newMd5" != "$oldMd5" ]; then
      docList[8*i+7]="${newMd5}"
    fi
    for (( j = 0 ; j < 8 ; j++ )); do
      echo "${docList[8*i+j]}" >> $newfile
    done
    mv -f "/tmp/$sourceName" "/tmp/$sourceName.$(( $RANDOM % 9000 + 1000 ))"
  done
}

renewTextbookMd5sums()
{
  textbook=( $(cat $1 | grep -v -E "^#") )
  newfile=$1.new
  echo "######################################################" > $newfile
  echo "# TEXTBOOKS: 10 lines per textbook:                  #" >> $newfile
  echo "# 0) General information URL                         #" >> $newfile
  echo "# 1) pdf download URL                                #" >> $newfile
  echo "# 2) license URL                                     #" >> $newfile
  echo "# 3) license icon                                    #" >> $newfile
  echo "# 4) source filename                                 #" >> $newfile
  echo "# 5) destination filename                            #" >> $newfile
  echo "# 6) Brief Title (in HTML, no spaces)                #" >> $newfile
  echo "# 7) Author (in HTML, no spaces)                     #" >> $newfile
  echo "# 8) md5sum                                          #" >> $newfile
  echo "# 9) Category                                        #" >> $newfile
  echo "######################################################" >> $newfile
  echo "#" >> $newfile
  echo "# Last updated $day" >> $newfile
  numTexts=$(( ${#textbook[@]} / 10 ))
  for (( i = 0 ; i < $numTexts ; i++ ))
  do
    echo "#" >> $newfile
    echo "#" >> $newfile
    downloadURL=${textbook[10*i+1]}
    sourceName=${textbook[10*i+4]}
    if [ ${textbook[10*i+1]:0:4} == "WGET" ]; then
      com="wget -P"
      downloadURL=${textbook[10*i+1]:4}
    else
      com="aria2c -d"
    fi
    echo "$com /tmp $downloadURL"
    $com /tmp $downloadURL
    newMd5=`md5sum "/tmp/$sourceName" | awk -F'  ' '{print $1}'`
    oldMd5=${textbook[10*i+8]}
    if [ "$newMd5" != "$oldMd5" ]; then
      textbook[10*i+8]="${newMd5}"
    fi
    for (( j = 0 ; j < 10 ; j++ )); do
      echo "${textbook[10*i+j]}" >> $newfile
    done
    mv -f "/tmp/$sourceName" "/tmp/$sourceName.$(( $RANDOM % 9000 + 1000 ))"
  done
  echo
}

#################
# Set variables #
#################
textbookList="./textbook.list"
geogebraDocList="./geogebraDoc.list"
maximaDocList="./wxmaximaDoc.list"
sageDocList="./sageDoc.list"
rDocList="./rDoc.list"
day=`date +"%e %B %Y"`

##########################
# Renew Textbook md5sums #
##########################
echo "Renewing textbook md5sums..."
renewTextbookMd5sums $textbookList

###############################
# Renew Documentation md5sums #
###############################
# Geogebra
echo "Renewing Geogebra documentation md5sums..."
renewDocumentationMd5sums $geogebraDocList
echo
# Maxima
echo "Renewing wxMaxima documentation md5sums..."
renewDocumentationMd5sums $maximaDocList
echo
# R
echo "Renewing R documentation md5sums..."
renewDocumentationMd5sums $rDocList
echo
# SAGE
echo "Renewing SAGE documentation md5sums..."
renewDocumentationMd5sums $sageDocList
echo
