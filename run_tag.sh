#!/bin/bash

tag_name=`grep GIT ../../../RELEASE_NOTES`
tag_length=${#tag_name}
tag_a=${tag_name:12:1}
tag_b=${tag_name:14:1}
tag_c=${tag_name:16:1}

echo ${tag_a}${tag_b}${tag_c}
