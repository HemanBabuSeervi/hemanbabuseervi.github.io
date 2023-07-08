TERM=ansi #bug-fix for tidy to work

language(){
	echo "<section class=\"$1 projectCategory\">" >> indexUnformatted.html
	echo "<h1>$(cat $1/HEAD)</h1>" >> indexUnformatted.html
	echo "<div class=content>" >> indexUnformatted.html
	for i in $(ls $1 | grep ".$1$") # The $ in the end of grep command means end of string
	do
        author="Coded by R. Heman"
        comment="//$author"
        if [[ $(head -1 $1/$i) != $comment ]]; then
            sed -i "1i $comment" $1/$i
        fi
		descfile=$1/$(echo $i | sed "s/.$1/.desc/ ")
		if [ ! -e $descfile ]; then
			nvim $descfile
		fi
		title=$(sed -n "1 p" $descfile)
		majorTags=$(sed -n "2 p" $descfile)
		minorTags=$(sed -n "3 p" $descfile)
        link=$(sed -n "4 p" $descfile)
		info=$(sed "1,4d" $descfile)

		echo "<div class=box>" >> indexUnformatted.html
		echo "<h2><a href=\"$link\">$title</a></h2>" >> indexUnformatted.html
		echo "$info" | sed -e '1i <div class=info>' -e '$a </div>' >> indexUnformatted.html
		echo "$majorTags" | sed 's# #</span><span>#g;s#^#<div class=majorTags><span>#;s#$#</span></div>#' >> indexUnformatted.html
		echo "$minorTags" | sed 's# #</span><span>#g;s#^#<div class=minorTags><span>#;s#$#</span></div>#' >> indexUnformatted.html
		echo "</div>" >> indexUnformatted.html
	done
	echo "</div></section>" >> indexUnformatted.html
}
backup(){
    if [[ -e $1 ]]; then
        backupExt=$(date +"%H-%M-%S=%d-%m-%Y")
        mkdir -p $(dirname "backup/$1")
        mv "$1" "backup/$1.$backupExt"
    fi
}

backup "index.html"

cat index-header.html > indexUnformatted.html
language "cpp"
language "java"
language "js"
cat index-footer.html >> indexUnformatted.html

tidy -indent --indent-spaces 4 --tidy-mark no -quiet indexUnformatted.html > index.html
rm indexUnformatted.html
