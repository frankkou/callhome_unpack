#!/bin/bash

for f in `find . -maxdepth 1 -type f` ; do
    #echo parsing $f
    if [[ "$f" =~ ([A-Za-z0-9_]*)-([A-Za-z0-9_-]*)-[a-f0-9]{8}-.*-([0-9]{4})-([0-9]{2})-([0-9]{2})T([0-9]{2}):([0-9]{2}):([0-9]{2}).*\.tar$ ]] ; then
        echo exteact nodes file $f to $dir ...
        customer=${BASH_REMATCH[1]}
        cluster=${BASH_REMATCH[2]}
        year=${BASH_REMATCH[3]}
        month=${BASH_REMATCH[4]}
        day=${BASH_REMATCH[5]}
        hour=${BASH_REMATCH[6]}
        minute=${BASH_REMATCH[7]}
        second=${BASH_REMATCH[8]}
        dir="$customer/$cluster/$year$month${day}_$hour$minute$second/"
        #echo found $customer, $cluster, $year, $month, $day, $hour, $minute, $second, $dir
        mkdir -p $dir
        tar xf $f -C $dir
        cd $dir
        for fn in `find tmp -type f` ; do
            if [[ "$fn" =~ tmp.*-[0-9]+\.[0-9]+\.[0-9]+\.([0-9]+)\.tar\.zst ]] ; then
                ip=${BASH_REMATCH[1]}
                echo extract $fn to directory $dir$ip
                mkdir $ip
                tar -xf $fn --use-compress-program `which unzstd` -C $ip 2>/dev/null
            else
                echo $fn is not expected
            fi
        done
        rm -rf tmp
        cd - >/dev/null
    elif [[ "$f" =~ ([A-Za-z0-9_]*)-([A-Za-z0-9_-]*)-[a-f0-9]{8}-.*-([0-9]{4})-([0-9]{2})-([0-9]{2})T([0-9]{2}):([0-9]{2}):([0-9]{2}).*\.tar\.zst$ ]] ; then
        customer=${BASH_REMATCH[1]}
        cluster=${BASH_REMATCH[2]}
        year=${BASH_REMATCH[3]}
        month=${BASH_REMATCH[4]}
        day=${BASH_REMATCH[5]}
        hour=${BASH_REMATCH[6]}
        minute=${BASH_REMATCH[7]}
        second=${BASH_REMATCH[8]}
        dir="$customer/$cluster/$year$month${day}_$hour$minute$second/"
        #echo found $customer, $cluster, $year, $month, $day, $hour, $minute, $second, $dir
        mkdir -p $dir
        echo extract vms file $f to directory ${dir}vms ...
        tar -xf $f --use-compress-program `which unzstd` -C $dir
        cd $dir
        mv tmp/tmp* vms
        rmdir tmp
        cd - >/dev/null
    fi
done
