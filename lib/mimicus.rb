require "mimicus/version"
require 'vmstat'

module Mimicus

    def Mimicus.getswap # To replace someday by a native ruby module
        `free | grep Swap | awk -F ' ' '{print "Swap: total="$2", used="$3", free="$4}'`
    end
    
    def Mimicus.getio # To replace someday by a native module too !!!
        `iostat | grep -A1  avg-cpu  | sed '/^$/d' | tail -n1| awk -F ' ' '{print "iostat: user="$1", nice="$2", system="$3", iowait="$4", steal="$5", idle="$6}'`
    end
    
    def Mimicus.getcpu
        cpuarr = Vmstat.cpu.map { |i| i.to_s }.join("")
        cpuarr = cpuarr.split(">")
        cpuarr = cpuarr.map {|e| e.gsub(/#<struct Vmstat::/,'')}
        cpuarr = cpuarr.map {|e| e.gsub(/Cpu/,'Cpu:')}
        return cpuarr
    end
    
    def Mimicus.getmem
        `free | grep Mem | awk -F ' ' '{print "Memory: total="$2", used="$3", free="$4", shared="$5", Buff/cache="$6", avail="$7}'`
    end
    
    def Mimicus.getloadavg
        loadavg = Vmstat.load_average
        loadavg = loadavg.to_s.gsub('#<struct Vmstat::LoadAverage', 'LoadAverage:')
        loadavg = loadavg.to_s.gsub('>', '')
        return loadavg
    end
    
    def Mimicus.getdiskpath
        i = `df | egrep -v "tmpfs|nfs"  | awk -F " " '{print $6}' | grep -v Mounted | xargs`
        i = i.split(" ")
     return i
    end
    
    def Mimicus.getdisk(d)
        disk = Vmstat.disk(d)
        disk = disk.to_s.gsub('#<struct Vmstat::', '')
        disk = disk.to_s.gsub('>', '')
        return disk
    end
    
    def Mimicus.getnics
        `egrep -v "face |Inter-|lo" /proc/net/dev | awk -F ": " '{print $1}'| xargs `#.split(",")
    end
    
    def Mimicus.getnicip(nic)
        `ip addr show dev #{nic} | awk -F "inet " '{print $2}' | sed '/^$/d' |  awk -F " " '{print $1}'` 
    end
    
    def Mimicus.getnicstat
        nicstats = Vmstat.network_interfaces.map { |i| i.to_s }.join("")
        
        nicstats = nicstats.split(">")
        nicstats = nicstats.map {|e| e.gsub(/#<struct Vmstat::/,'')}
        nicstats = nicstats.map {|e| e.gsub(/Cpu/,'Cpu:')}
        nicstats = nicstats.map {|e| e.gsub(/, type=24/,'')} # We don't need that in the mimic DB
        nicstats = nicstats.map {|e| e.gsub(/, type=nil/,'')} # We don't need that in the mimic DB
    
        for line in nicstats
            nicstats.delete line if line.include? ":lo,"
            return nicstats
         end
    end
    
    def Mimicus.command?(command)
        system("which #{ command} > /dev/null 2>&1")
    end
  
end
