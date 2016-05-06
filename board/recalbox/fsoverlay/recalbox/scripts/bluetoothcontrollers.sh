#!/bin/bash                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                              
killall bluetoothd                                                                                                                                                                                                                            
# If rpi3, load the firmware for bluetooth manually, and start it
if [ -f /boot/bcm2710-rpi-3-b.dtb ]; then
    /usr/bin/hciattach /dev/ttyAMA0 bcm43xx 921600
    /usr/bin/hciconfig hci0 up 
fi

repeat=1                                                                                                                                                                                                                                      
lag=5                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                              
while true                                                                                                                                                                                                                                    
do                                                                                                                                                                                                                                            
    let repeat++                                                                                                                                                                                                                              
    connected=`hcitool con 2>/dev/null | tail -n+2 | grep "state 1" | cut -f3 -d' '`                                                                                                                                                          
    waitForMe=""                                                                                                                                                                                                                              
    for bt in $(cat /var/lib/bluetooth/known_devices 2>/dev/null )                                                                                                                                                                            
    do                                                                                                                                                                                                                                        
        skip=0                                                                                                                                                                                                                                
        for skipping in $connected; do                                                                                                                                                                                                        
            if [[ "$skipping" == "$bt" ]]; then                                                                                                                                                                                               
                skip=1                                                                                                                                                                                                                        
            fi                                                                                                                                                                                                                                
        done                                                                                                                                                                                                                                  
                                                                                                                                                                                                                                              
        [ "$skip" == "1" ] && continue                                                                                                                                                                                                        
        echo -e 'connect $bt' | bluetoothctl 2>/dev/null &
        waitForMe="$waitForMe $!"                                                                                                                                                                                                             
    done                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                              
    for toWait in $waitForMe; do                                                                                                                                                                                                              
        wait $toWait                                                                                                                                                                                                                          
    done                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                              
    if [[ "$repeat" -gt "10" ]];then                                                                                                                                                                                                          
        lag=10                                                                                                                                                                                                                                
    fi                                                                                                                                                                                                                                        
                                                                                                                                                                                                                                              
    sleep $lag                                                                                                                                                                                                                                
done
