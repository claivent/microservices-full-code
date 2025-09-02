````shell
for i in cp1 cp2 cp3 w1 w2; do
    incus config set "$i" limits.memory=2096MiB
    echo "$i limit.memory set"
    incus config set "$i" limits.cpu=1
    echo "$i limit.cpu set"
done

for i in cp1 cp2 cp3 w1 w2; do
    incus stop $i 
    echo "$i stopped"  
done

````