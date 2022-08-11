#!/bin/bash

# Channel Code
CHANNEL_CODE=""
SLACK_TOKEN=""

# Get Text from 'https://boletimsec.com.br/boletim-diario-ciberseguranca/' to boletim.html file
curl -s https://boletimsec.com.br/boletim-diario-ciberseguranca/ > boletim1.txt

# Get element by js path from boletim.html file to boletim.txt file
xmllint --html --xpath "/html/body/div[1]/main/section[2]/div/div/div[2]/div/div/div[2]" boletim1.txt 1> boletim2.txt 2> /dev/null

# Format date to dd/mm/yyyy
DATE=$(date +%d/%m/%Y)

# Create file and header
echo "# Boletim de Segurança" > boletim3.txt
echo "--> Data: $DATE" >> boletim3.txt

# Get all data to boletim3.txt
awk '{gsub(/<[^>]*>/,"")}1' boletim2.txt >> boletim3.txt

# Delete last four lines
sed -i '$ d' boletim3.txt
sed -i '$ d' boletim3.txt
sed -i '$ d' boletim3.txt
sed -i '$ d' boletim3.txt

# For any line start with '*' insert blank line before
sed -i 's/^\*/\n*/g' boletim3.txt

# For any line start with '*' remove it and insert ':point_right: ' before it
sed -i 's/^\*/:point_right: /g' boletim3.txt

# On end of file insert
# Agradecimentos ao Thierre Madureira de Souza
# Automação desenvolvida pelo /tisautomation/
echo "" >> boletim3.txt
echo "" >> boletim3.txt
echo "_Agradecimentos ao Thierre Madureira de Souza pela inspiração_" >> boletim3.txt
echo "_Automação desenvolvida por /Enderson Menezes/_" >> boletim3.txt
echo "Fonte: \`https://boletimsec.com.br/boletim-diario-ciberseguranca/\`" >> boletim3.txt

# Curl boletim3.txt
curl -d "text=$(cat boletim3.txt)" -d "channel=$CHANNEL_CODE" -H "Authorization: Bearer $SLACK_TOKEN" -X POST https://slack.com/api/chat.postMessage