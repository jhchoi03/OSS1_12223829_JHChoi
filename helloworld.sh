#!/bin/bash
echo "--------------------------"
echo "User Name: JeongHyuk Choi"
echo "Student Number: 12223829"
echo "[MENU]"
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item'
2. Get the data of action genre movies from 'u.item’
3. Get the average 'rating’ of the movie identified by specific 'movie id' from 'u.data’
4. Delete the ‘IMDb URL’ from ‘u.item
5. Get the data about users from 'u.user’
6. Modify the format of 'release date' in 'u.item’
7. Get the data of movies rated by a specific 'user id' from 'u.data'
8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'
9. Exit"
echo "--------------------------"
read -p "Enter your choice [1-9] " reply

while [[ $reply -ne 9 ]]
do
	if [[ $reply -eq 1 ]]
	then
		echo

		read -p  "Please enter the 'movie id' (1~1682):" reply2
	
		echo
		awk -F '|' -v id="$reply2" '$1 == id {print $0}' "$1"

		echo	

	elif [[ $reply -eq 2 ]]
	then
	
		echo
		read -p "Do you want to get the data of ‘action’ genre movies from 'u.item’?(y/n):" reply2
		echo

		if [[ $reply2 = "y" ]]
		then
			awk -F '|' '$7 == 1 {print $1 " " $2}' "$1" | sort -n | head -n 10
			echo


		fi
	elif [[ $reply -eq 3 ]]
	then
		echo

		read -p "Please enter the 'movie id’(1~1682):" reply2
		echo

		awk -F ' ' -v id="$reply2" 'BEGIN { sum = 0; cnt = 0 }$2 == id {sum = sum + $3; cnt = cnt + 1}  END { temp = sprintf("%.5f", sum/cnt);  print id ": " temp  }' "$2" 
		echo
	

	elif [[ $reply -eq 4 ]]
	then
		echo
 		read -p "Do you want to delete the ‘IMDb URL’ from ‘u.item’?(y/n): " reply2
		echo

		if [[ $reply2 = "y" ]]
		then
			head -n 10 "$1" | sed 's|http[^|]*||g'
			echo

		fi
	
	
	elif [[ $reply -eq 5 ]]
	then
		echo

		read -p "Do you want to get the data about users from
‘u.user’?(y/n): " reply2
		echo

		if [[ $reply2 = "y" ]]
		then
			sed -n '1,10p' "$3" | sed -E -e 's/([0-9]*)\|([0-9]*)\|([MF])\|([^|]*)\|([0-9]*)/user \1 is \2 years old \3 \4/' | sed -e 's/F/female/g' | sed -e 's/M/male/g'
			echo

		fi

	elif [[ $reply -eq 6 ]]
	then
		echo

	read -p "Do you want to Modify the format of ‘release data’ in ‘u.item’?(y/n): " reply2
	echo
		if [[ $reply2 = "y" ]] 
		then
			tail -n 10 "$1" | sed -r 's|([0-9]+)-([A-Za-z]+)-([0-9]+)|\3\2\1|g; s/Jan/01/g; s/Feb/02/g; s/Mar/03/g; s/Apr/04/g; s/May/05/g; s/Jun/06/g; s/Jul/07/g; s/Aug/08/g; s/Sep/09/g; s/Oct/10/g; s/Nov/11/g; s/Dec/12/g'
			echo
			
		fi	

	elif [[ $reply -eq 7 ]]
	then
		echo
		read -p "Please enter the ‘user id’(1~943): " reply2

		echo

		awk -F ' ' -v id="$reply2" '$1 == id {print $2}' "$2" |	sort -n | tr '\n' '|'

		echo -e "\n"

		tmp=$(awk -F ' ' -v id="$reply2" '$1 == id {print $2}' "$2" | sort -n | head -n 10)
		for va in $tmp 
		do
			awk -F '|' -v id="$va" '$1 == id {print $1 "|" $2}' "$1"
		done
		echo

	elif [[ $reply -eq 8 ]]
	then

		echo
		
		read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n): " reply2

		echo

		if [[ $reply2 = "y" ]]
		then
			ddd=$(awk '{print $1 "|" $2 "|" $3 }' "$2" | sort -n)
			echo "$ddd" | awk -F '|' ' $2 >= 20 && $2 <= 29 && $4 == "programmer" { tmp[$1]=1; next }
			$1 in tmp { tmp2[$2]+=$3; tmp3[$2]++ } END {for (i in tmp2) printf "%s %f\n", i, tmp2[i]/tmp3[i] }' "$3" - | awk -F ' ' '{printf "%s %.5f\n", $1, $2}' | awk -F ' ' '{printf "%s %s\n", $1, sprintf("%.5f", $2)+0}'	
			echo

		fi
	
	fi

	read -p "Enter your choice [1-9] " reply
done

echo "Bye!"

