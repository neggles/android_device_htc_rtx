#!/system/bin/sh

target=`getprop ro.board.platform`

function configure_zram_disksize() {
# Configure different zram size based on real RAM size.
# zram size = RAM size / 2

    MemTotalStr=`cat /proc/meminfo | /vendor/bin/sed '2,$d'`
    MemTotal=${MemTotalStr:16:8}
    ZramDiskSize=$(/vendor/bin/expr $MemTotal \* 512)

    zram_enable=`getprop ro.config.zram`
    echo $ZramDiskSize > /sys/block/zram0/disksize

    mkswap /dev/block/zram0
    swapon /dev/block/zram0 -p 32758
}

case "$target" in
    "msm8994")
        setprop  sys.sysctl.extra_free_kbytes 58500
        echo "0,200,300,700,900,906" > /sys/module/lowmemorykiller/parameters/adj
        echo "27648,41472,48384,110778,122775,160275" > /sys/module/lowmemorykiller/parameters/minfree
	#Enable adaptive LMK and set vmpressure_file_min by HTC setting
	echo 1 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
	echo 159375 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min
        ;;
esac

case "$target" in
    "sdm660")
	if [ -f /sys/devices/soc0/soc_id ]; then
		soc_id=`cat /sys/devices/soc0/soc_id`
        else
                soc_id=`cat /sys/devices/system/soc/soc0/id`
        fi
	#Apply settings for sdm630
        case "$soc_id" in
            "318" | "327" )
		setprop  sys.sysctl.extra_free_kbytes 58500
		echo "0,200,300,700,900,906" > /sys/module/lowmemorykiller/parameters/adj
		echo "27648,41472,48384,110778,122775,160275" > /sys/module/lowmemorykiller/parameters/minfree
		#Enable adaptive LMK and set vmpressure_file_min by HTC setting
		echo 1 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
		echo 159375 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min

		echo 0-1 > /dev/cpuset/background/cpus
		echo 0-3 > /dev/cpuset/system-background/cpus
		echo 0-7 > /dev/cpuset/top-app/cpus
		echo 0-7 > /dev/cpuset/foreground/cpus
		echo 1 > /proc/sys/vm/drop_caches
		;;
	esac
	;;
esac

case "$target" in
    "msm8952")
        if [ -f /sys/devices/soc0/soc_id ]; then
            soc_id=`cat /sys/devices/soc0/soc_id`
        else
            soc_id=`cat /sys/devices/system/soc/soc0/id`
        fi
        case "$soc_id" in
            "264" | "289")
                # 8952
                setprop  sys.sysctl.extra_free_kbytes 72900
                echo "0,200,300,700,900,906" > /sys/module/lowmemorykiller/parameters/adj
                echo "27648,41472,48384,59578,71575,109075" > /sys/module/lowmemorykiller/parameters/minfree
                echo 1 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
                echo 146575 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min
                ;;
            *)
                # 8976
                setprop  sys.sysctl.extra_free_kbytes 129600
                echo "0,200,300,700,900,906" > /sys/module/lowmemorykiller/parameters/adj
                echo "27648,41472,48384,110778,122775,160275" > /sys/module/lowmemorykiller/parameters/minfree
                echo 1 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
                echo 159375 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min
                ;;
        esac
        ;;
esac

case "$target" in
    "msm8996")
        setprop  sys.sysctl.extra_free_kbytes 129600
        echo "0,200,300,700,900,906" > /sys/module/lowmemorykiller/parameters/adj
        echo "27648,41472,48384,72378,84375,121875" > /sys/module/lowmemorykiller/parameters/minfree
        # minfree: 27648,41472,48384,72378,84375,121875
        # vmpressure_file_min = 121875+(121875-84375) =  159375
        echo 159375 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min
        ;;
esac

case "$target" in
    "msm8998")
        setprop  sys.sysctl.extra_free_kbytes 129600
        echo "0,200,300,700,900,906" > /sys/module/lowmemorykiller/parameters/adj
        echo "27648,41472,48384,72378,84375,121875" > /sys/module/lowmemorykiller/parameters/minfree
        # minfree: 27648,41472,48384,72378,84375,121875
        # vmpressure_file_min = 121875+(121875-84375) =  159375
        echo 159375 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min
        echo 0 > /dev/cpuset/cpu_exclusive
        echo 0-1 > /dev/cpuset/background/cpus
        echo 0-2 > /dev/cpuset/system-background/cpus
        echo 0-7 > /dev/cpuset/foreground/cpus
        echo 0-7> /dev/cpuset/foreground/boost/cpus
        echo 0-7 > /dev/cpuset/top-app/cpus
        log -p v -t CPUSET "cpuset background $(cat /dev/cpuset/background/cpus)"
        log -p v -t CPUSET "cpuset system-background $(cat /dev/cpuset/system-background/cpus)"
        log -p v -t CPUSET "cpuset foreground $(cat /dev/cpuset/foreground/cpus)"
        log -p v -t CPUSET "cpuset foreground/boost $(cat /dev/cpuset/foreground/boost/cpus)"
        ;;
esac

case "$target" in
    "msm8909")
        echo "0,100,200,300,900,906" > /sys/module/lowmemorykiller/parameters/adj
        echo "18432,23040,27648,42496,54493,66993" > /sys/module/lowmemorykiller/parameters/minfree
        echo 1 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
        echo 79493 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min
esac

case "$target" in
    "sdm845")
        # 1440x2880x4x3x3/1024=145800
        # setprop  sys.sysctl.extra_free_kbytes 145800
        echo 362 > /proc/sys/vm/watermark_scale_factor
        echo "0,200,300,700,900,906" > /sys/module/lowmemorykiller/parameters/adj
        echo "27648,41472,48384,72378,84375,121875" > /sys/module/lowmemorykiller/parameters/minfree
        # minfree: 27648,41472,48384,72378,84375,121875
        # vmpressure_file_min = 121875+(121875-84375) =  159375
        echo 159375 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min
        echo 0 > /dev/cpuset/cpu_exclusive
        echo 0-1 > /dev/cpuset/background/cpus
        echo 0-3 > /dev/cpuset/system-background/cpus
        echo 0-7 > /dev/cpuset/foreground/cpus
        echo 0-7> /dev/cpuset/foreground/boost/cpus
        echo 0-7 > /dev/cpuset/top-app/cpus
        ;;
esac

case "$target" in
    "msmnile")
        # 1280x720x4x3x3/1024 = 32400
        # setprop  sys.sysctl.extra_free_kbytes 32400
        # 362 = (vmpressure_file_min/4) / (zone->managed_pages) x 10000
        echo 362 > /proc/sys/vm/watermark_scale_factor
        echo "0,200,300,700,900,906" > /sys/module/lowmemorykiller/parameters/adj
        echo "27648,41472,48384,72378,84375,121875" > /sys/module/lowmemorykiller/parameters/minfree
        # vmpressure_file_min = 121875 + (121875-84375) = 159375
        echo 159375 > /sys/module/lowmemorykiller/parameters/vmpressure_file_min
        echo 0 > /dev/cpuset/cpu_exclusive
        echo 0-1 > /dev/cpuset/background/cpus
        echo 0-3 > /dev/cpuset/system-background/cpus
        echo 0-7 > /dev/cpuset/foreground/cpus
        echo 0-7 > /dev/cpuset/top-app/cpus
        ;;
esac

#common part
case "$target" in
    *)
        echo 1 > /proc/sys/vm/highmem_is_dirtyable
        # Configure zram size
        configure_zram_disksize
        echo 600 > /sys/module/lowmemorykiller/parameters/adj_max_shift
        echo 80 > /sys/module/vmpressure/parameters/allocstall_threshold
        ;;
esac
