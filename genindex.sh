TERM=ansi

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
blog(){
    #blogHead="<section id=\"blog\"><h2>Blog</h2><div class=\"content\">"
    cat blog/index-header.html > blogUnformatted.html
    for year in $(ls blog/[0-9][0-9][0-9][0-9] -d); do
        year=$(basename $year)
        for month in $(ls blog/$year/[0-9][0-9] -d); do
            month=$(basename $month)
            for day in $(ls blog/$year/$month/[0-9][0-9].html); do
                day=$(basename $day)
                title="$(echo $day | sed 's/.html//')-$month-$year"
                notes="$(cat blog/$year/$month/$day)"
                echo "<div class=\"day\"><h3>$title</h3><div class=notes>$notes</div></div>" >> blogUnformatted.html
            done
        done
    done
    cat blog/index-footer.html >> blogUnformatted.html
}
backup(){
    if [[ -e $1 ]]; then
        backupExt=$(date +"%H-%M-%S=%d-%m-%Y")
        mkdir -p $(dirname "backup/$1")
        mv "$1" "backup/$1.$backupExt"
    fi
}

backup "index.html"
backup "blog/index.html"

cat index-header.html > indexUnformatted.html
language "cpp"
language "java"
language "js"
blog
cat index-footer.html >> indexUnformatted.html

tidy -indent --indent-spaces 4 --tidy-mark no -quiet indexUnformatted.html > index.html
tidy -indent --indent-spaces 4 --tidy-mark no -quiet blogUnformatted.html > blog/index.html
rm indexUnformatted.html blogUnformatted.html
