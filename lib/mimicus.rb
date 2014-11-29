require "mimicus/version"
require 'vmstat'

#$PROGRAM_NAME = "mimicus-agent"

module Mimicus

    
    def self.getpid
        pid = `pgrep -f "#{$PROGRAM_NAME} | head -n1"`
        return pid
    end

    def self.getswap # To replace someday by a native ruby module
        `free | grep Swap | awk -F ' ' '{print "\\"Swap\\" : {\\"total\\":\\""$2"\\", \\"used\\":\\""$3"\\", \\"free\\":\\""$4"\\"},"}'`
    end
    
    def self.getio # To replace someday by a native module too !!!
        `iostat | grep -A1  avg-cpu  | sed '/^$/d' | tail -n1| awk -F ' ' '{print "\\"iostat\\" : {\\"user\\":\\""$1"\\", \\"nice\\":\\""$2"\\", \\"system\\":\\""$3"\\", \\"iowait\\":\\""$4"\\", \\"steal\\":\\""$5"\\", \\"idle\\":\\""$6"\\"},"}'`
    end
 
    def self.top(comp)
       top = `ps axo ruser,%#{comp},comm,pid,euser --sort=-%#{comp} | head -n 11 | tail -n 10 | awk -F " " '{print "{\\"user\\":\\""$1"\\", \\"#{comp}\\":\\""$2"\\", \\"cmd\\":\\""$3"\\", \\"pid\\":\\""$4"\\"},"}'`
       top = top.to_s
       top = top.chomp
       return top
    end
   
    def self.getcpu
        #   The number of the cpu starting at 0 for the first cpu.
        #   Current counter of ticks spend in user. The counter can overflow.
        #   Current counter of ticks spend in system. The counter can overflow.
        #   Current counter of ticks spend in nice. The counter can overflow.
        #   Current counter of ticks spend in idle. The counter can overflow.
        cpuarr = Vmstat.cpu.map { |i| i.to_s }.join("")
        #cpuarr = cpuarr.map {|e| e.gsub(/>/,'}')}
        cpuarr = cpuarr.split(">")
        cpuarr = cpuarr.map {|e| e.gsub(/#<struct Vmstat::/,'')}
        cpuarr = cpuarr.map {|e| e.gsub(/Cpu /,'"Cpu" : {\"')}
        cpuarr = cpuarr
        return cpuarr #+ "\}"
    end
    
    def self.getuname
        return `uname -a`.chomp
    end

    def self.getmem
        `free | grep Mem | awk -F ' ' '{print "\\"memory\\" : {\\"total\\":\\""$2"\\", \\"used\\":\\""$3"\\", \\"free\\":\\""$4"\\", \\"shared\\":\\""$5"\\", \\"Buff/cache\\":\\""$6"\\", \\"avail\\":\\""$7"\\"},"}'`
    end
    
    def self.getcpustats
        `vmstat -a | tail -n1 | awk -F ' ' '{print "\\"cpustat\\" : {\\"us\\":\\""$13"\\", \\"sys\\":\\""$14"\\", \\"id\\":\\""$15"\\", \\"wa\\":\\""$16"\\", \\"steal\\"=\\""$17"\\"},"}'`
    end

    def self.getloadavg
        loadavg = Vmstat.load_average
        loadavg = loadavg.to_s.gsub('#<struct Vmstat::LoadAverage ', '"LoadAverage" : {')
        loadavg = loadavg.to_s.gsub('>', '"},')
        loadavg = loadavg.to_s.gsub('one_minute=', '"one_minute":"')
        loadavg = loadavg.to_s.gsub(', five_minutes=', '", "five_minutes":"')
        loadavg = loadavg.to_s.gsub(', fifteen_minutes=', '", "fifteen_minutes":"')
        return loadavg
    end
    
    def self.getdiskpath
        i = `df | egrep -v "tmpfs|nfs"  | awk -F " " '{print $6}' | grep -v Mounted | xargs`
        i = i.split(" ")
     return i
    end
    
    def self.getdisk(d)
        disk = Vmstat.disk(d)
        disk = disk.to_s.gsub('#<struct Vmstat::', '')
        disk = disk.to_s.gsub('>', '')
        disk = disk.to_s.gsub(/^/,'{')
        return disk
    end
    
    def self.getnics
        #`egrep -v "face |Inter-|lo" /proc/net/dev | awk -F ": " '{print $1}'| xargs `#.split(",")
        `egrep -v "face |Inter-|lo" /proc/net/dev | awk -F ": " '{print $1}'| xargs`
    end
    
    def self.getnicip(nic)
        `ip addr show dev #{nic} | awk -F "inet " '{print $2}' | sed '/^$/d' |  awk -F " " '{print $1}'` 
    end
    
    def self.getnicstat
        nicstats = Vmstat.network_interfaces.map { |i| i.to_s }.join("")
        
        nicstats = nicstats.split(">")
        nicstats = nicstats.map {|e| e.gsub(/#<struct Vmstat::/,'')}
        #nicstats = nicstats.map {|e| e.gsub(/Cpu/,'Cpu:')}
        nicstats = nicstats.map {|e| e.gsub(/NetworkInterface name=:/,'ifstat" : {"nic":"')}
        nicstats = nicstats.map {|e| e.gsub(/, type=24/,'')} # We don't need that in the mimic DB
        nicstats = nicstats.map {|e| e.gsub(/, type=nil/,'')} # We don't need that in the mimic DB
        #nicstats = nicstats.map {|e| e.gsub(' "ifstat" ','"ifstat" ')} # We don't need that in the mimic DB

        #nicstats = nicstats.map {|e| e.gsub(/, /,', :')}
    
        return nicstats
        #for line in nicstats
        #    nicstats.delete line if line.include? "\"lo\""
        #    return nicstats 
        # end
    end
    
    def self.command?(command)
        system("which #{ command} > /dev/null 2>&1")
    end
  
end
