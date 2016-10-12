fn="try3"
sites=("apple.com" "microsoft.com" "amazon.com" "google.com" "reddit.com" "netflix.com")
for i in "${sites[@]}"
do
	:
	ipv4s=$(host $i | grep -oP "$i has address \K.*")
	ipv6s=$(host -t AAAA $i | grep -oP "$i has IPv6 address \K.*")
	mails=$(host $i | grep -oP "$i mail is handled by [0-9]* \K.*(?=.)")
	nss=$(host -t ns $i | grep -oP "$i name server \K.*(?=.)")
	nsips=()
	nsttls=()
	for ns in $nss
	do
		:
		nsips="$nsips $(nslookup -type=A -debug $ns | grep -oP 'internet address = \K[0-9.]*')"
		nsttls="$nsttls $(nslookup -type=A -debug $ns | grep -oP 'ttl = \K[0-9.]*')"
	done
	echo "$i" >> $fn.csv
	vars=("ipv4s" "ipv6s" "mails" "nss" "nsips" "nsttls")
	for var in "${vars[@]}"
	do
		:
		out=""
		for ele in ${!var}
		do
			:
			if [ "$out" != "" ]
				then
					out="$out, $ele"
				else
					out="$ele"
			fi
		done
		echo "$out" >> $fn.csv
	done
done
#
