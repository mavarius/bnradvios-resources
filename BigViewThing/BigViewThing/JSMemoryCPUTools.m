//
//  JSMemoryCPUTools.m
//  BigViewThing
//
//  Created by Jonathan Saggau on 7/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "JSMemoryCPUTools.h"

#import <mach/mach.h>
#import <mach/mach_host.h>

//http://landonf.bikemonkey.org/code/iphone/Determining_Available_Memory.20081203.html
static void print_free_memory () {
    mach_port_t host_port;
    mach_msg_type_number_t host_size;
    vm_size_t pagesize;
    
    host_port = mach_host_self();
    host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);        
    
    vm_statistics_data_t vm_stat;
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS)
        NSLog(@"Failed to fetch vm statistics");
    /* Stats in bytes */ 
    natural_t mem_used = (vm_stat.active_count +
                          vm_stat.inactive_count +
                          vm_stat.wire_count) * pagesize;
    natural_t mem_free = vm_stat.free_count * pagesize;
    natural_t mem_total = mem_used + mem_free;
    NSLog(@"used: %u free: %u total: %u", mem_used, mem_free, mem_total);
}

//http://www.opensource.apple.com/source/top/top-38/libtop.c
//http://www.sfr-fresh.com/unix/privat/ganglia-3.1.2.tar.gz:a/ganglia-3.1.2/libmetrics/darwin/metrics.c
static void
print_cpu_info ()
{
    static unsigned long long last_userticks, userticks, last_totalticks, totalticks, diff;
    mach_msg_type_number_t count;
    host_cpu_load_info_data_t cpuStats;
    kern_return_t	ret;
    float val;
    mach_port_t host_port;
    
    count = HOST_CPU_LOAD_INFO_COUNT;
    host_port = mach_host_self();
    ret = host_statistics(host_port,HOST_CPU_LOAD_INFO,(host_info_t)&cpuStats,&count);
    
    if (ret != KERN_SUCCESS) {
        NSLog(@"print_cpu_info() got an error from host_statistics()");
        return;
    }
    
    userticks = cpuStats.cpu_ticks[CPU_STATE_USER];
    totalticks = cpuStats.cpu_ticks[CPU_STATE_IDLE] + cpuStats.cpu_ticks[CPU_STATE_USER] +
    cpuStats.cpu_ticks[CPU_STATE_NICE] + cpuStats.cpu_ticks[CPU_STATE_SYSTEM];
    diff = userticks - last_userticks;
    
    if ( diff )
        val = ((float)diff/(float)(totalticks - last_totalticks))*100;
    else
        val = 0.0;
    
    NSLog(@"CPU percentage: %f\n", val);
    
    last_userticks = userticks;
    last_totalticks = totalticks;
    
}

@implementation JSMemoryCPUTools

+(void)printCPUInfo;
{
    print_free_memory();
}
+(void)printMEMInfo;
{
    print_cpu_info();
}
@end
