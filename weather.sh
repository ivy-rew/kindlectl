. kindlectlOp.sh

power(){
  state=$(. kindlectlOp.sh && powerStatus | grep "Powerd state: ")
  echo "${state:14}"
}

state=$(power)
echo "state is!${state}!"
if [[ "$state" == "Screen Saver" ]]; then
  powerToggle
fi


clear && curl -H "Accept-Language: de" wttr.in?2nTF
sleep 2
screenshot
newscreen=$(ls /mnt/us/screenshot* | tail -n 1)
echo "captured: $newscreen"

if [[ "$state" == "Screen Saver" ]]; then
  powerToggle
fi


sleep 5
eips -g $newscreen
