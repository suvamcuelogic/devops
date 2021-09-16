
# Modified

function isEmailValid() {
      regex="^([A-Za-z]+[A-Za-z0-9]*((\.|\-|\_)?[A-Za-z]+[A-Za-z0-9]*){1,})@(([A-Za-z]+[A-Za-z0-9]*)+((\.|\-|\_)?([A-Za-z]+[A-Za-z0-9]*)+){1,})+\.([A-Za-z]{2,})+"
      [[ "${1}" =~ $regex ]]
}




filename='emails.txt'
n=1
while read line; do
# reading each line
echo "Sl No: $n || email: $line"

if isEmailValid $line ;then
    echo "Valid Email Address"
else
    echo  "Not Valid !"
fi

n=$((n+1))
done < $filename



# 1st Approach
 
filename='emails.txt'
n=1
while read line; do
# reading each line
echo "Sl No: $n || email: $line"

regex="^(([-a-zA-Z0-9\!#\$%\&\'*+/=?^_\`{\|}~]+|(\"([][,:;<>\&@a-zA-Z0-9\!#\$%\&\'*+/=?^_\`{\|}~-]|(\\\\[\\ \"]))+\"))\.)*([-a-zA-Z0-9\!#\$%\&\'*+/=?^_\`{\|}~]+|(\"([][,:;<>\&@a-zA-Z0-9\!#\$%\&\'*+/=?^_\`{\|}~-]|(\\\\[\\ \"]))+\"))@\w((-|\w)*\w)*\.(\w((-|\w)*\w)*\.)*\w{2,4}$"


if [[ "$line" =~ $regex ]] ; then
    echo "Valid Email Address"
else
    echo  "Not Valid !"
fi

n=$((n+1))
done < $filename
