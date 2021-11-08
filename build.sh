#!/usr/bin/env bash

BASE=$(dirname $0)

if [ -f .env ]; then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

if [[ -z $TOKEN ]]; then
    echo "missing TOKEN env parameter"

    exit 1
fi

function get_follower()
{
    curl -sqH "Authorization: Bearer $TOKEN" \
        "https://api.twitter.com/2/users/by/username/$1?user.fields=public_metrics" | jq '.data.public_metrics.followers_count'
}

lyrixx_followers_count=$(get_follower "lyrixx")
jolicode_followers_count=$(get_follower "jolicode")
diff=$((jolicode_followers_count - lyrixx_followers_count))

if (( diff < 0 )); then
    cp $BASE/yes.html $BASE/docs/index.html
    echo "yes"
else
    cp $BASE/no.html $BASE/docs/index.html
    sed -i "s/{{ diff }}/$diff/" $BASE/docs/index.html
    echo "non"
fi

echo "$(date '+%Y-%m-%d %H:%M:%S');$lyrixx_followers_count;$jolicode_followers_count" >> data.csv
