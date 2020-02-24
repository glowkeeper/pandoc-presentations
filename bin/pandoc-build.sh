#!/bin/bash

# e.g
# pandoc-build.sh source.md paper
#
# All being well, the above command will output
# ../build/paper/source.pdf

# or
# pandoc-build.sh source.md presentation
#
# All being well, the above command will output
# ../build/presentation/index.html
# and put reveal.js in ./build/presentation/

function install_precheck {

	for FILE in `echo "${src_md}"`
 	do
		#echo $FILE
		#target_name="`basename ${FILE} | sed 's/\(.*\)\..*/\1/'`"
		src_dir="`dirname ${FILE}`"

		if [ ! -f "${FILE}" ]
		then
			echo "error: the source markdown (${FILE}) does not exist!"
			exit 1
		fi

		#If the markdown has image references, check for the actual images
		if [ -n "`grep '(images/' ${FILE}`" ]
		then
			if [ ! -d "${src_dir}/${src_images}" ]
			then
				echo "error: the image directory ${src_dir}/${src_images} does not exist!"
				exit 1
			elif [ -z "`ls ${src_dir}/${src_images}`" ]
			then
				echo "error: there are no images!"
				exit 1
			fi
		fi

		#If the markdown has video references, check for the actual images
		if [ -n "`grep '(videos/' ${FILE}`" ]
		then
			if [ ! -d "${src_dir}/${src_videos}" ]
			then
				echo "error: the video directory ${src_dir}/${src_videos} does not exist!"
				exit 1
			elif [ -z "`ls ${src_dir}/${src_videos}`" ]
			then
				echo "error: there are no videos!"
				exit 1
			fi
		fi
	done

	# Change directory to the markdown source directory so the image references in the source resolve correctly
	cd ${src_dir}
}

function install_paper {

	#echo "Source dir is ${src_dir}"
	src_meta="meta.yml"
	src_biblio="bibliography/library.bib"
	src_csl="bibliography/apa.csl"

	target_dir="${this_dir}/build/paper/${target_name}"
	target_paper="${target_dir}/${target_name}.docx"

	if [ ! -f "${src_biblio}" ]
	then
		echo "error: the source bibliography ${src_dir}/${src_biblio} does not exist!"
		exit 1
	fi

	if [ ! -f "${src_csl}" ]
	then
		echo "error: the source csl ${src_dir}/${src_csl} does not exist!"
		exit 1
	fi

	if [ ! -f "${src_meta}" ]
	then
		echo "error: the source meta ${src_dir}/${src_meta} does not exist!"
		exit 1
	fi

	if [ ! -d "${target_dir}" ]
    then
		mkdir -p "${target_dir}"
	fi

	#pandoc --normalize --toc --metadata link-citations=true --filter pandoc-citeproc -V documentclass=report "${src_meta}" "${src_md}" --biblio "${src_biblio}" --csl "${src_csl}" --pdf-engine=xelatex -s -S -o "${target_paper}"
	#echo "pandoc --metadata link-citations=true --filter pandoc-citeproc -V documentclass=report ${src_meta} --biblio ${src_biblio} --csl ${src_csl} --latex-engine=xelatex -s -o ${target_paper}"
	#pandoc --metadata-file=${src_meta} link-citations=true --filter pandoc-citeproc -V documentclass=report ${src_meta} ${src_md} --biblio ${src_biblio} --csl ${src_csl} --pdf-engine=xelatex -s -o ${target_paper}
	pandoc --metadata link-citations=true --filter pandoc-citeproc -V documentclass=report ${src_meta} ${src_md} --biblio ${src_biblio} --csl ${src_csl} --pdf-engine=xelatex -s -o ${target_paper}
}

function install_presentation {

	src_meta="meta.yml"
	src_css="${target_name}.css"
	src_reveal="${this_dir}/library/reveal.js"

	target_dir="${this_dir}/build/presentation/${target_name}"
	target_html="${target_dir}/index.html"
	target_reveal="${target_dir}/reveal.js"

	# Possible reveal themes
	# Black (default) - White - League - Sky - Beige - Simple
	# Serif - Blood - Night - Moon - Solarized
	# Liked themes
	# Black, White, Night, Solarized
	theme="white"
	transition="linear"

	if [ ! -f "${src_meta}" ]
	then
		echo "error: the source meta ${src_meta} does not exist!"
		exit 1
	fi

	if [ ! -f "${src_css}" ]
	then
		echo "error: the source css ${src_css} does not exist!"
		exit 1
	fi

	if [ ! -d "${src_reveal}" ]
	then
		echo "error: ${src_reveal} does not exist. Please download reveal (https://github.com/hakimel/reveal.js/) and copy it into ${src_reveal}"
		exit 1
	fi

	if [ ! -d "${target_dir}" ]
	then
		mkdir -p "${target_dir}"
	fi

	#pandoc -s -S --section-divs --variable theme="$theme" --variable transition="$transition" -t revealjs -H "${src_css}" "${src_md}" -o "${target_html}"
	#pandoc --metadata-file=${src_meta} --section-divs --variable theme=$theme --variable transition=$transition -t revealjs -H ${src_css} ${src_md} -o ${target_html}
	pandoc --section-divs --variable theme=$theme --variable transition=$transition -t revealjs -H ${src_css} ${src_md} -o ${target_html}

	# Now place images, videos and reveal
	if [ -d "${src_images}" ]
	then
		cp -fRp "${src_images}" "${target_dir}"
	fi
	if [ -d "${src_videos}" ]
	then
		cp -fRp "${src_videos}" "${target_dir}"
	fi
	if [ ! -d "${target_reveal}" ]
	then
		cp -fRp "${src_reveal}" "${target_reveal}"
		cd "${target_reveal}" && npm install && cd -
	fi
}

if [ -z "`which pandoc`" ]
then
	echo "error: you must install pandoc!"
	exit 1
fi

#if [ -z "`which xelatex`" ]
#then
#	echo "error: you must install LaTeX (or BasicTeX)!"
#	exit 1
#fi

target_name=$1
action=$2
shift 2
src_md=$@

#echo $target_name
#echo $action
#echo $src_md

if [ -z "$target_name" ]
then
	echo "usage: $0 outputName {presentation||paper} input"
	exit 1
fi

if [ -z "$action" ]
then
	echo "usage: $0 outputName {presentation||paper} input"
	exit 1
fi

if [ -z "$src_md" ]
then
	echo "usage: $0 outputName {presentation||paper} input"
	exit 1
fi

this_dir="`dirname $(pwd)`"
src_dir=""
src_images="images"
src_videos="videos"

case "$action" in
  presentation)
		install_precheck
    install_presentation
    ;;
  paper)
		install_precheck
    install_paper
    ;;
  *)
    echo "usage: $0 outputName {presentation||paper} input"
		exit 1
esac
