#!/bin/bash

#  Build the doxygen documentation for the project and load the docset into Xcode.
#  Use the following to adjust the value of the $DOXYGEN_PATH User-Defined Setting:
#    Binary install location: /Applications/Doxygen.app/Contents/Resources/doxygen
#    Source build install location: /usr/local/bin/doxygen
#  If the config file doesn't exist, run 'doxygen -g $SOURCE_ROOT/doxygen.config' to
#   a get default file.

# Debug
#set -x

if [ -z $1 ]; then
echo "Usage: $0 input_path"
exit 1
fi

if [ ! -d $1 ]; then
echo "Directory $1 does not exist!"
exit 1
fi

VERSION=`agvtool vers -terse`
INPUT_DIR="$1"
DOXYGEN_PATH="/Applications/Doxygen.app/Contents/Resources/doxygen"
OUTPUT_DIRECTORY="$PROJECT_TEMP_DIR/doc"
DOXYGEN_FILE="$PROJECT_TEMP_DIR/Doxyfile.sh"
INSTALL_SCRIPT="$PROJECT_TEMP_DIR/loadDocSet.scpt"
DOCSET_ID="com.codingcobra.$PRODUCT_NAME"
DOCSET_PATH="$HOME/Library/Developer/Shared/Documentation/DocSets/$DOCSET_ID.docset"
LOG_FILE="$OUTPUT_DIRECTORY/doxygen_log_file.txt"
LOGO="$PROJECT_DIR/res/images/Icon@2x.png"
SYNOPSIS="iOS Client"

CURRENT_XCODE=$(basename $(xcode-select -print-path | cut -d . -f1))

rm -f $LOG_FILE
rm -f $INSTALL_SCRIPT
rm -f $DOXYGEN_FILE
rm -rf $OUTPUT_DIRECTORY

if ! [ -f $DOXYGEN_FILE ]
then
echo "doxygen config file does not exist... create one..."
$DOXYGEN_PATH -g $DOXYGEN_FILE
fi

case "$DEVELOPMENT_LANGUAGE" in
English|German|de|en)
OUTPUT_LANGUAGE="$DEVELOPMENT_LANGUAGE"
;;
*)
OUTPUT_LANGUAGE=English
;;
esac

cat <<EOF >> $DOXYGEN_FILE

# Append the proper config values to the doxygen.config file.
INPUT                  = "$INPUT_DIR"
RECURSIVE              = "YES"
PROJECT_NAME           = "$PRODUCT_NAME"
PROJECT_NUMBER         = "$VERSION"
PROJECT_BRIEF          = "$SYNOPSIS"
PROJECT_LOGO           = "$LOGO"
OUTPUT_DIRECTORY       = "$OUTPUT_DIRECTORY"
OUTPUT_LANGUAGE        = "$OUTPUT_LANGUAGE"
BRIEF_MEMBER_DESC      = YES
JAVADOC_AUTOBRIEF      = YES
INHERIT_DOCS           = YES
CREATE_SUBDIRS         = YES
GENERATE_HTML          = YES
GENERATE_LATEX         = NO
GENERATE_RTF           = NO
GENERATE_MAN           = NO
GENERATE_XML           = NO
GENERATE_PERLMOD       = NO
HTML_OUTPUT            = html
GENERATE_DOCSET        = YES
DOCSET_FEEDNAME        = "$PRODUCT_NAME v. $VERSION API Documentation"
DOCSET_BUNDLE_ID       = "$DOCSET_ID"
DOCSET_PUBLISHER_ID    = "com.codingcobra"
DOCSET_PUBLISHER_NAME  = Coding Cobra
HIDE_UNDOC_MEMBERS     = NO
HIDE_UNDOC_CLASSES     = NO
HIDE_UNDOC_RELATIONS   = NO
REPEAT_BRIEF           = YES
CASE_SENSE_NAMES       = YES
INLINE_INHERITED_MEMB  = YES
SHOW_FILES             = YES
SHOW_INCLUDE_FILES     = YES
EXTRACT_ALL            = YES
EXTRACT_PRIVATE        = YES
EXTRACT_STATIC         = YES
EXTRACT_LOCAL_METHODS  = NO
TAB_SIZE               = 4
EXCLUDE_PATTERNS       += .*
#EXCLUDE_PATTERNS       += *DTLibrary*
MACRO_EXPANSION        = YES
EXPAND_AS_DEFINED      = YES
PREDEFINED             = DT_DECLARE_STRING(name)=extern NSString * const name DT_DECLATE_KEY(name)=extern NSString * const name
EXTENSION_MAPPING      = Objective-C
WARN_NO_PARAMDOC       = YES
WARN_LOGFILE           = $LOG_FILE
SOURCE_BROWSER         = YES
#DOT_IMAGE_FORMAT       = svg
#INTERACTIVE_SVG        = YES
#HAVE_DOT               = YES

GENERATE_TODOLIST      = YES
GENERATE_TESTLIST      = YES
GENERATE_BUGLIST       = YES
GENERATE_DEPRECATEDLIST= YES

EOF

#  Run doxygen on the updated config file.
#  Note: doxygen creates a Makefile that does most of the heavy lifting.

echo "Executing Doxygen command with config file $DOXYGEN_FILE"
$DOXYGEN_PATH $DOXYGEN_FILE

#  make will invoke docsetutil. Take a look at the Makefile to see how this is done.

make -C "$OUTPUT_DIRECTORY/html" install

#  Construct a temporary applescript file to tell Xcode to load a docset.

rm -f $INSTALL_SCRIPT

cat <<EOF >> $INSTALL_SCRIPT

tell application "$CURRENT_XCODE"
load documentation set with path "$DOCSET_PATH"
end tell

EOF

#  Run the load-docset applescript command
osascript $INSTALL_SCRIPT

# Cleanup
#rm -f $LOG_FILE
#rm -f $DOXYGEN_FILE
#rm -rf $OUTPUT_DIRECTORY
#rm -f $INSTALL_SCRIPT

exit 0