#!/bin/bash

tag_name=`git tag`
tag_length=${#tag_name}
tag_a=${tag_name:$tag_length-5:1}
tag_b=${tag_name:$tag_length-3:1}
tag_c=${tag_name:$tag_length-1:1}

echo ${tag_a}${tag_b}${tag_c}
