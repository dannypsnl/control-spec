new_proj_name=$1

# repo name
sed -i "" "s/idris-project/$new_proj_name/g" ./package.ipkg
sed -i "" "s/idris-project/$new_proj_name/g" ./README.md

# author name
if [ -z $2 ]; then echo "keep origin github id"; else sed -i "" "s/dannypsnl/$2/g" ./package.ipkg; fi
if [ -z $3 ]; then echo "keep origin author name"; else sed -i "" "s/Lîm Tsú-thuàn/$3/g" ./package.ipkg; fi
