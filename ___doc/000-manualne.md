
```shell
kubectl create token k8s-dashboard -n default
```
pridat do mongo db customer a notification a role pro alibou


claivent@claivent-virtual-machine:~/IdeaProjects/microservices-full-code/services$ k logs zipkin-74459d97fb-2fw29

                  oo
                 oooo
                oooooo
               oooooooo
              oooooooooo
             oooooooooooo
           ooooooo  ooooooo
          oooooo     ooooooo
         oooooo       ooooooo
        oooooo   o  o   oooooo
       oooooo   oo  oo   oooooo
     ooooooo  oooo  oooo  ooooooo
    oooooo   ooooo  ooooo  ooooooo
oooooo   oooooo  oooooo  ooooooo
oooooooo      oo  oo      oooooooo
ooooooooooooo oo  oo ooooooooooooo
oooooooooooo  oooooooooooo
oooooooo  oooooooo
oooo  oooo

     ________ ____  _  _____ _   _
    |__  /_ _|  _ \| |/ /_ _| \ | |
      / / | || |_) | ' / | ||  \| |
     / /_ | ||  __/| . \ | || |\  |
    |____|___|_|   |_|\_\___|_| \_|

:: version 3.5.1 :: commit b7e2258 ::

2025-08-04T10:42:28.339Z  WARN [/] 1 --- [           main] i.m.p.PrometheusMeterRegistry            : A MeterFilter is being configured after a Meter has been registered to this registry. All MeterFilters should be configured before any Meters are registered. If that is not possible or you have a use case where it should be allowed, let the Micrometer maintainers know at https://github.com/micrometer-metrics/micrometer/issues/4920. Enable DEBUG level logging on this logger to see a stack trace of the call configuring this MeterFilter.
2025-08-04T10:42:29.173Z  INFO [/] 1 --- [oss-http-*:9411] c.l.a.s.Server                           : Serving HTTP at /[0:0:0:0:0:0:0:0]:9411 - http://127.0.0.1:9411/



for i in cp3 do
echo "xxxxxx Přidávám kontejner $i xxxxxx"

MAC="00:16:3e:cc:95:$(echo -n "$i" | sha256sum | cut -c1-2)"

incus launch images:ubuntu/jammy/cloud $i \
--config security.nesting=true \
--config security.privileged=true \
--config linux.kernel_modules=overlay,br_netfilter

echo "xxxxxx Přidávám síťové zařízení eth0 s MAC adresou $MAC xxxxxx"
incus config device add $i eth0 nic \
nictype=bridged \
parent=br0 \
hwaddr=$MAC

echo "xxxxxx Přidávám config raw.lxc do kontejneru $i xxxxxx"
incus config set $i raw.lxc "lxc.apparmor.profile=unconfined
lxc.cgroup.devices.allow = a
lxc.cap.drop = "

echo "xxxxxx Přidávám speciální zařízení do kontejneru $i xxxxxx"
incus config device add $i kmsg unix-char path=/dev/kmsg major=1 minor=11 mode=0666
incus config device add $i sysctl-overcommit-memory disk source=/proc/sys/vm/overcommit_memory path=/proc/sys/vm/overcommit_memory
incus config device add $i sysctl-kernel-panic disk source=/proc/sys/kernel/panic path=/proc/sys/kernel/panic
incus config device add $i sysctl-kernel-panic-on-oops disk source=/proc/sys/kernel/panic_on_oops path=/proc/sys/kernel/panic_on_oops

incus restart $i

echo "$i hotovo xxxxxxxxxxxxxxx"
done

echo "xxxxxx Konec vytvoření incus kontejnerů xxxxxx"