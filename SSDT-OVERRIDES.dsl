// Copyright: black.dragon74

// Code is poetry

// IMPORTANT: If you use sorted order, this SSDT should load immediately after OEM SSDTs

// This SSDT is used to disable bogus devices that are not needed by macOS
// This SSDT also injects new devices according to original Apple Laptops

// Before using this SSDT make sure you remove any conflicting Name or Method properties from your native ACPI tables

// Meant specifically for ASUS A555LA, but, might work for other laptops
// _STA to XSTA renames required in DSDT & SSDTs: DptfTabl, CpccTabl, SaSSDT
// Serach for "Renamed" in this file to see OEM TABLE ID of SSDT in which you have to apply renames

// If you get FAN RPM as 255 it means your FAN is at it's maximum speed

// TODO: What this ssdt does
    
DefinitionBlock("SSDT-OVERRIDES", "SSDT", 2, "Nick", "AsusOpt", 0)
{

    External (B1B2, MethodObj)
    External (\_PR.CPU0, DeviceObj)
    External (\_SB, DeviceObj)
    External (\_SB.ASHS, DeviceObj)
    External (\_SB.PCCD, DeviceObj)
    External (\_SB.IETM, DeviceObj)
    External (\_SB.TPM, DeviceObj)
    External (\_SB.PCI0, DeviceObj)
    External (\_SB.PCI0.ADP1, DeviceObj) // Requires rename of AC0 to ADP1 in DSDT
    External (\_SB.PCI0.B0D3, DeviceObj)
    External (\_SB.PCI0.B0D4, DeviceObj)
    External (\_SB.PCI0.D02B, DeviceObj)
    External (\_SB.PCI0.D02C, DeviceObj)
    External (_SB_.PCI0.EH01, DeviceObj)
    External (_SB_.PCI0.EH02, DeviceObj)
    External (\_SB.PCI0.GFX0, DeviceObj)
    External (\_SB.PCI0.HDEF, DeviceObj)
    External (\_SB.PCI0.HECI, DeviceObj)
    External (\_SB.PCI0.LPCB, DeviceObj)
    External (\_SB.PCI0.SIRC, DeviceObj)
    External (\_SB.PCI0.SMB0, DeviceObj) // Requires rename of BAT0 to SMB0
    External (\_SB.PCI0.LPCB.ADBG, DeviceObj)
    External (\_SB.PCI0.LPCB.CWDT, DeviceObj)
    External (\_SB.PCI0.LPCB.DMAC, DeviceObj)
    External (\_SB.PCI0.LPCB.FWHD, DeviceObj)
    External (\_SB.PCI0.LPCB.IPIC, DeviceObj)
    External (\_SB.PCI0.LPCB.LDRC, DeviceObj)
    External (\_SB.PCI0.LPCB.TIMR, DeviceObj)
    External (\_SB.PCI0.LPCB.EC0, DeviceObj) // For EC related queries
    External (\_SB.PCI0.LPCB.PS2K, DeviceObj) // For brightness controls
    External (\_SB.PCI0.LPCB.EC0.ECAV, MethodObj) // Check if EC (Embedded controller) is ready
    External (\_SB.PCI0.LPCB.EC0.ST83, MethodObj) // FAN values in bytes are stored here
    External (\_SB.PCI0.LPCB.EC0.ST98, MethodObj) // Method that can acquire mutex and set FAN QMOD || QMOD = Max Allowed RPM of FAN
    External (\_SB.PCI0.LPCB.EC0.TACH, MethodObj) // Returns FAN speed in RPM unit
    External (\_SB.PCI0.LPCB.EC0.ECPU, FieldUnitObj) // Current CPU Temperature
    External (\_SB.PCI0.RP03, DeviceObj)
    External (\_SB.PCI0.RP04, DeviceObj)
    External (\_SB.PCI0.PDRC, DeviceObj)
    External (\_SB.PCI0.SBUS, DeviceObj)
    External (\_SB.PCI0.TPCH, DeviceObj)
    External (\_SB.PCI0.XHC, DeviceObj)
    External (\_SB.PCI0.RP03.PXSX, DeviceObj)
    External (\_SB.PCI0.RP03.GLAN, DeviceObj)
    External (\_SB.PCI0.RP04.PXSX, DeviceObj)
    External (\_SB.PCI0.RP04.WLAN, DeviceObj)
        
    // DO NOT REMOVE this device, it takes care of few stuffs in this SSDT
    Device (ANKD) // ANKD = A Nick's Device
    {
        // Because this is required
        Name (_HID, "ANKD0000")
        
        // Configurations for this SSDT, change according to your system
        Name (IUSB, 1)  // Change this to 0 if you don't have ASUS A555LA || IUSB = Inject USB
        Name (PTYP, 1) // Processor Type: Use 1 for Hasw/Bdw || 2 for SKL/KBL || PTYP = Processor Type
        Name (AUDL, 5) // Audio layout of your AppleHDA
        Name (IALS, 1) // Set this to 0 if you don't want to inject a fake ALS (Ambient Light Sensor) device
        Name (IPLT, 1) // Set this to 1 if you want to inject "plugin-type" on CPU0
        Name (HSOA, 1) // Set this to 0 if you don't want to add FirstPollDelay for ACPIBatMgr || HSOA = High Sierra or above
        Name (CFPD, 6000) // Comment if you don't want FirstPollDelay for ACPIBatteryManager, only works if HSOA is set to 1.
        Name (ICFC, 1) // Use custom FAN control, set to 0 if you don't want it
        Name (IBKP, 1) // Inject brightness key patch for ApplePS2SmartTouchpad, Set to 0 if you don't want to
        
        Method (_INI, 0)
        {
            Store ("Loaded Optimizer SSDT", Debug)
        }
    }
            
    // Begin disabling unwanted devices
    Scope (\_SB)
    {
        // Renamed _STA to XSTA in DSDT
        Scope (ASHS)
        {
            Name (_STA, Zero)
        }
        
        // Renamed _STA to XSTA in SSDT (DptfTabl)
        Scope (IETM)
        {
            Name (_STA, Zero)
        }
        
        // Renamed _STA to XSTA in SSDT (CpccTabl)
        Scope (PCCD)
        {
            Name (_STA, Zero)
        }
        
        // Renamed _STA to XSTA in DSDT
        Scope (TPM)
        {
            Name (_STA, Zero)
        }            
    }        
        
    Scope (\_SB.PCI0)
    {
        // Disable B0D3 Device, HDAU is injected by HaswHDA SSDT
        // Method _STA renamed to XSTA in SSDT (SaSSDT)
        Scope (B0D3)
        {
            If (\ANKD.PTYP != 2)
            {
                Name (_STA, Zero)
            }    
        }
        
        // Disable bogus B0D4 device
        // Method _STA renamed to XSTA in SSDT (DptfTabl)
        Scope (B0D4)
        {
            Name (_STA, Zero)
        }
        
        // Disable bogus D02B device
        Scope (D02B)
        {
            Name (_STA, Zero)
        }
        
        // Disable bogus D02C device
        Scope (D02C)
        {
            Name (_STA, Zero)
        }
        
        // Disable EHCI controller
        Scope (EH01)
        {
            OperationRegion (ANP1, PCI_Config, 0x54, 0x02)
            Field (ANP1, WordAcc, NoLock, Preserve)
            {
                PSTE,   2 // Power State
            }
        }
        
        // Disable EHCI controller
        Scope (EH02)
        {
            OperationRegion (ANP1, PCI_Config, 0x54, 0x02)
            Field (ANP1, WordAcc, NoLock, Preserve)
            {
                PSTE,   2 // Power State
            }
        }        
        
        // Disable GFX0, IGPU is injected by IntGFX SSDT
        Scope (GFX0)
        {
            Name (_STA, Zero)
        }
        
        // Disable HECI device, IMEI will be injected by this SSDT
        Scope (HECI)
        {
            Name (_STA, Zero)
        }                      
        
        Scope (RP03)
        {
            // Disable PXSX Device
            Scope (PXSX)
            {
                Name (_STA, Zero)
            }

            // Disable GLAN Device
            Scope (GLAN)
            {
                Name (_STA, Zero)
            }
        }
        
        Scope (RP04)
        {

            // Disable PXSX Device
            Scope (PXSX)
            {
                Name (_STA, Zero)
            }
            
            // Disable WLAN Device
            Scope (WLAN)
            {
                Name (_STA, Zero)
            }
        }
        
        Scope (LPCB)
        {
            // Disable unwanted ADBG device
            Scope (ADBG)
            {
                Name (_STA, Zero)
            }
            
            // Disable unwanted CWDT Device
            // Renamed _STA to XSTA in DSDT
            Scope (CWDT)
            {
                Name (_STA, Zero)
            }
            
            // Disable unwanted DMAC device
            Scope (DMAC)
            {
                Name (_STA, Zero)
            }
            
            // Disable unwanted FWHD device
            Scope (FWHD)
            {
                Name (_STA, Zero)
            }
            
            // Disable unwated IPIC device
            Scope (IPIC)
            {
                Name (_STA, Zero)
            }
            
            // Disable unwanted LDRC device
            Scope (LDRC)
            {
                Name (_STA, Zero)
            }
            
            // Disable unwanted TIMR device
            Scope (TIMR)
            {
                Name (_STA, Zero)
            }
            
            // Disable EHCI controller
            OperationRegion (ANP1, PCI_Config, 0xF0, 0x04)
            Field (ANP1, DWordAcc, NoLock, Preserve)
            {
                RCB1,   32 // Root complex Base
            }

            OperationRegion (FDM1, SystemMemory, Add (And (RCB1, 0xFFFFFFFFFFFFC000), 0x3418), 0x04)
            Field (FDM1, DWordAcc, NoLock, Preserve)
            {
                    ,   13, 
                FDE2,   1, 
                    ,   1, 
                FDE1,   1
            }
                       
        }
        
        // Don't Disable bogus SBUS device
        //Scope (SBUS)
        //{
        //    Name (_STA, Zero)
        //}
        
        // Disable bogus TPCH Device
        // Method _STA renamed to XSTA in SSDT (DptfTabl)
        Scope (TPCH)
        {
            Name (_STA, Zero)
        }
        
        // Disable bogus PDRC device
        Scope (PDRC)
        {
            Name (_STA, Zero)
        } 
        
        // Disable unwanted SIRC device
        // Renamed _STA to XSTA in DSDT
        Scope (SIRC)
        {
            Name (_STA, Zero)
        }                               
    }
    // End disabling devices
    
    // Start injecting new devices
    // Inject plugin type 1 for native power management
    // Set ANKD.IPLT to 0 if you are using ssdtprgen
    // Set ANKD.IPLT to 0 if you are injecting plugi type in config.plist
    Scope (\_PR.CPU0)
    {
        // Inject plugin related methods
        Method (_DSM, 4)
        {
            // For debugging
            Debug = "CPUPM: _DSM Called for CPU0"
            
            // If Arg2 is Zero return 0x03 as buffer
            If (Arg2 == 0)
            {
                Debug = "CPUPM: Arg2 found as Zero. Not injecting"
                Return (Buffer()
                {
                    0x03
                })
            }
            
            // If IPLT is set to Zero, don't inject anything
            If (\ANKD.IPLT == 0)
            {
                Debug = "CPUPM: IPLT set to zero in ANKD. Not injecting"
                Return (0)
            }
            
            // If Processor is above haswell, inject plugin-tpye on CPU0
            If (\ANKD.PTYP >=1)
            {
                Debug = "CPUPM: Injected plugin-type on CPU0"
                Return(Package()
                {
                    "plugin-type", 1
                })
            }
            
            // Else. don't inject
            Else
            {
                Debug = "CPUPM: Processor not above haswell. Not Injecting"
                Return (0)
            }    
        }                    
    }        
    
    Scope (\_SB)
    {
        Device (EC)
        {
            Name (_HID, "EC000000")
        }
        
        // Inject ALS device
        Device (ALS)
        {
            Name (_HID, "ACPI0008") // According to Apple
            Name (_CID, "smc-als") // According to Apple
            Name (_ALI, 300) // According to Apple and _ALR package
            Name (_ALR, Package()
            {
                //Package() { 70, 0 },
                //Package() { 73, 10 },
                //Package() { 85, 80 },
                Package() { 100, 300 },
                //Package() { 150, 1000 },
            })
            
            // Read config from ANKD and enable/disable device accordingly
            If (CondRefOf(\ANKD.IALS))
            {
                If (\ANKD.IALS == 0)
                {
                    Name (_STA, 0) // Turn off the device
                }
            }                   
        }    
    }
            
    Scope (\_SB.PCI0)
    {
        // Make Apple ACPI Battery Manager load
        Scope (ADP1)
        {
            Name (_PRW, Package() { 0x18, 0x03 })
        }
        
        // Add FirstPollDelay for ACPIBatteryManager on HighSierra+
        Scope (SMB0)
        {
            Method (RMCF, 0)
            {
                Local0 = Package()
                {
                    "FirstPollDelay", 4000
                }
                
                // If CFPD exists, then change the value of FirstPollDelay wrt ANKD.CFPD
                External (\ANKD.CFPD, IntObj)
                If (CondRefOf(\ANKD.CFPD))
                {
                    CreateDWordField(DerefOf(Local0[1]), 0, CFPD)
                    CFPD = \ANKD.CFPD
                    
                    // A little bit of debug info
                    Debug = "Injected custom FirstPollDelay for ACPIBatteryManager"
                    Debug = \ANKD.CFPD
                }
                Else
                {
                    Debug = "Custom FirstPollDelay not found. Using default: 4000"
                }    
                
                // Return the final package, by checking if running macOS 10.13+
                If (CondRefOf(\ANKD.HSOA))
                {
                    If (\ANKD.HSOA == 1)
                    {
                        Return (Local0)
                    }
                    Else
                    {
                        Return (0)
                    }
                }
                Else
                {
                    Return (0)
                }        
            }           
        }    
            
        Scope (RP03)
        {
            // Inject ethernet device with compliance to Apple
            Device (GIGE)
            {
                Name (_ADR, Zero)

                Method (_INI, 0)
                {
                    Store ("Injected GIGE Device upon Disabling GLAN", Debug)
                }    
                
                Method (_RMV, 0)
                {
                    Return (Zero)
                }
            }
        }
        
        Scope (RP04)
        {
            // Inject ARPT (Wi-Fi) device
            Device (ARPT)
            {
                Name (_ADR, Zero)
                Name (_PRW, Package (0x02)
                {
                    0x09, 
                    0x04
                })
                
                Method (_INI, 0)
                {
                    Store ("Injected ARPT Device upon Disabling WLAN", Debug)
                }
                
                Method (_RMV, 0)
                {
                    Return (Zero)
                }
                
                Method (_DSM, 4)
                {
                    Store (Package ()
                    {
                        "model", 
                        Buffer (0x1E)
                        {
                            "Atheros AR9565 a/b/g/n Wireless"
                        }, 
                        "device_type", 
                        Buffer (0x08)
                        {
                            "AirPort"
                        }, 
                        "built-in", 
                        Buffer (One)
                        {
                            0x00
                        }, 
                        "name", 
                        Buffer (0x10)
                        {
                            "AirPort Extreme"
                        }, 
                        "AAPL,slot-name", 
                        Buffer (0x09)
                        {
                            "Internal"
                        }, 
                        "compatible",
                        Buffer (0x0B)
                        {
                            "pci168c,30"
                        }
                    }, Local0)
                    
                    Store ("Injected ARPT Device Properties", Debug)
                    
                    Return (Local0)    
                }
            }
        }
        
        // Inject Intel Graphics properties that are missing from non apple ACPI tables
        Device (IGPU)
        {
            // Get device id from PCI config
            OperationRegion(IGD5, PCI_Config, 0, 0x14)
            
            // Basic name address
            Name (_ADR, 0x00020000)
            
            Method (_DSM, 4)
            {
                If (LEqual (Arg2, Zero))
                {
                    Return (Buffer (One)
                    {
                         0x03                                           
                    })
                }

                Return (Package (0x02)
                {
                    "hda-gfx", 
                    Buffer (0x0A)
                    {
                        "onboard-1"
                    }
                })
            }
            
            // Inject PNLF device for AppleBacklight
            // Based on RehabMan's PNLF
            Device (PNLF)
            {
                Name (_ADR, 0) // Because this is required
                Name (_HID, EisaId ("APP0002")) // Apple Panel Hardware ID
                Name (_CID, "backlight") // So that your device is compatible
                Name (_UID, 0) // Will be sed by _INI method
                Name (_STA, 0x0b) // As found on macbooks
                
                Field(^IGD5, AnyAcc, NoLock, Preserve)
                {
                    Offset(0x02), GDID,16,
                    Offset(0x10), BAR1,32,
                }
                
                OperationRegion(RMB1, SystemMemory, BAR1 & ~0xF, 0xe1184)
                Field(RMB1, AnyAcc, Lock, Preserve)
                {
                    Offset(0x48250),
                    LEV2, 32,
                    LEVL, 32,
                    Offset(0x70040),
                    P0BL, 32,
                    Offset(0xc8250),
                    LEVW, 32,
                    LEVX, 32,
                    Offset(0xe1180),
                    PCHL, 32,
                }
                
                // Init this device
                Method (_INI, 0)
                {
                    Local0 = GDID // Store GDID in Local0
                    
                    // Store value of ANKD.PTYP in Local3
                    Store (\ANKD.PTYP, Local3)
                    If (Local3 == 1)
                    {
                        Store (0xad9, Local2) // Haswell or Broadwell
                    }
                    ElseIf (Local3 == 2)
                    {
                        Store (0x56c, Local2) // Skylake or Kabylake
                    }
                    Else
                    {
                        Store (Zero, _STA) // Disable device due to invalid option in ANKD.PTYP
                    }
                    
                    // Value called after display sleep (RehabMan)
                    LEVW = 0xC0000000
                    
                    // Change scale
                    Local1 = LEVX >> 16
                    If (!Local1) { Local1 = Local2 }
                    If (Local2 != Local1)
                    {
                        // set new backlight PWMAX
                        Local0 = (((LEVX & 0xFFFF) * Local2) / Local1) | (Local2 << 16)
                        LEVX = Local0
                    }
                    
                    // Now we set the device UID
                    If (Local2 == 0xad9) { _UID = 15 } // Haswell or Broadwell
                    ElseIf (Local2 == 0x56c) { _UID = 16 } // Skylake or Kabylake
                    Else { _UID = 99 } // Unknown            
                }
            }        
         }
        
        // Inject properties for HDMI audio. You need patches to config.plist with this for it to work
        Device (HDAU)
        {
            Name (_ADR, 0x00030000)  // _ADR: Address
            // HDAU is not needed on SKL/KBL
            Method (_STA, 0)
            {
                If (\ANKD.PTYP == 2)
                {
                    Return (0)
                }
                Else
                {
                    Return (15) // macOS uses 0x0f (15) as default _STA for some reason.
                }
            }           

            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If (LEqual (Arg2, Zero))
                {
                    Return (Buffer (One)
                    {
                         0x03                                           
                    })
                }

                Local0 = Package (0x04)
                {
                    "layout-id", 
                    Buffer (4)
                    {
                         0x03, 0x00, 0x00, 0x00                         
                    },

                    "hda-gfx", 
                    Buffer ()
                    {
                        "onboard-1"
                    }, 
                }
                
                // Read AUDL property and change layout-id buffer's value
                // CondRefOf not really needed here, but, just in case.
                If (CondRefOf(\ANKD.AUDL))
                {
                    CreateDWordField(DerefOf(Local0[1]), 0, AUDL)
                    AUDL = \ANKD.AUDL
                }
                
                // Return the package
                Return (Local0)
            }
        }
        
        // If your ACPI tables doesn't have HDEF device, uncomment the lines below
        //Device(HDEF)
        //{
        //    Name(_ADR, 0x001b0000)
        //    Name(_PRW, Package() { 0x0d, 0x05 }) // may need tweaking (or not needed)
        //}
        
        // Add audio device properties. Make sure you have changed conflicting _DSM to XDSM in DSDT
        Scope (HDEF)
        {
            Method (_DSM ,4)
            {
                If (!Arg2)
                {
                    Return (Buffer()
                    {
                        0x03
                    })
                }
                
                // Don't return the package, instead, store it in a variable
                Local0 = Package()
                {
                    "layout-id", Buffer(4)
                    {
                        3, 0, 0, 0
                    },
                    "hda-gfx", Buffer()
                    {
                        "onboard-1"
                    },
                    "PinConfigurations", Buffer()
                    {
                        // Inject custom pin configuration if you want to
                    },            
                }
                
                // Read AUDL property and change layout-id buffer's value
                If (CondRefOf(\ANKD.AUDL))
                {
                    CreateDWordField(DerefOf(Local0[1]), 0, AUDL)
                    AUDL = \ANKD.AUDL
                }
                
                // Return Local0 package (our device properties)
                Return (Local0)                
            }
        }        
        
        // Add a new device and initialize it to put EHCI in D3hot state
        Device (DECI)
        {
            Name (_HID, "DECI0000")  // _HID: Hardware ID
            Method (_INI, 0, NotSerialized)  // _INI: Initialize
            {
                Store (3, ^^EH01.PSTE)
                Store (1, ^^LPCB.FDE1)
                Store (3, ^^EH02.PSTE)
                Store (1, ^^LPCB.FDE2)
            }
        }
        
        // Add compatible LPCB properties
        Scope (LPCB)
        {
            Method (_DSM, 4)
            {
                Store (\ANKD.PTYP, Local0)
                If (!Arg2)
                {
                    Return (Buffer()
                    {
                        0x03
                    })
                }
                
                If (Local0 == 1)
                {
                    Local1 =  Package()
                    {
                        "compatible", "pci8086,9c43"
                    }
                }
                ElseIf (Local0 ==2)
                {
                    Local1 = Package()
                    {
                        "compatible", "pci8086,9cc1",
                    }
                }
                
                Return (Local1)                       
            }
            
            // Check and add brightness related methods
            // Renamed _Q0E to XQ0E and _Q0F to XQ0F in DSDT
            Scope (EC0)
            {
                Method (_Q0E, 0)
                {   
                    If (\ANKD.IBKP != 0)
                    {
                        Notify (PS2K, 32)
                    }    
                }
                     
                Method (_Q0F, 0)
                {
                    If (\ANKD.IBKP != 0)
                    {
                        Notify (PS2K, 16)
                    }    
                }                
            }
        }
            
        // Add SMBUS device compatible properties
        Scope (SBUS)
        {            
            // Add BUS0 device to SBUS (SMBUS) based on work by RehabMan
            Device (BUS0)
            {
                Name (_CID, "smbus") // Just so it is compatible
                Name (_ADR, 0) // Required
                
                // Add DVL0 device
                Device (DVL0)
                {
                    Name (_ADR, 0x57) //Address is required
                    Name (_CID, "diagsvault") // Compatible with Diag Vault
                    
                    // DSM method to inject properties
                    Method (_DSM ,4)
                    {
                        If (!Arg2)
                        {
                            Return (Buffer()
                            {
                                0x03
                            })
                        }
                        
                        // Else return address
                        Return (Package()
                        {
                            "address", 0x57
                        })
                    }
                }                    
            }    
        }
        
        // Add MCHC device
        Device (MCHC)
        {
            Name (_ADR, 0)
        }
        
        // Add IMEI device
        Device (IMEI)
        {
            Name(_ADR, 0x00160000) // From DSDT
            
            Method (_DSM, 4)
            {
                Return (Package()
                {
                    //
                })
            }        
        }
        
        // Inject properties for XHCI controller
        // Properties for EHCI are not injected as we have disabled the EHCI device
        Scope (XHC)
        {
            Method (_DSM, 4)
            {
                If (!Arg2)
                {
                    Return (Buffer()
                    {
                        0x03
                    })
                }
                
                // Return properties
                Return (Package()
                {
                    "subsystem-id", Buffer() { 0x70, 0x72, 0x00, 0x00 },
                    "subsystem-vendor-id", Buffer() { 0x86, 0x80, 0x00, 0x00 },
                    "AAPL,current-available", Buffer() { 0x34, 0x08, 0, 0 },
                    "AAPL,current-extra", Buffer() { 0x98, 0x08, 0, 0, },
                    "AAPL,current-extra-in-sleep", Buffer() { 0x40, 0x06, 0, 0, },
                    "AAPL,max-port-current-in-sleep", Buffer() { 0x34, 0x08, 0, 0 },
                })            
            }
        }                                              
    }
    
    // Add methods to read FAN RPM in compliance to FakeSMC_ACPI_Sensors
    Device (SMCD)
    {
        Name (_HID, "FAN0000")
        Name (_STA, 1) // Just so that we could turn device on and off as required
        Name (TACH, Package()
        {
            "System Fan", "FAN0"
        })
        
        // Add package wrt ACPISensors
        Name (TEMP, Package()
        {
            "CPU Heatsink", "TCPU"
        })
            
        Method (FAN0, 0)
        {
            // Check is EC is ready
            If (\_SB.PCI0.LPCB.EC0.ECAV())
            {
                // Continue
                Local0 = \_SB.PCI0.LPCB.EC0.ST83(0)
                If (Local0 == 255)
                {
                    // Store it in debug log
                    Debug = "FAN0 is at maximum speed now"
                    Return (Local0)
                }
                
                // Get RPM and store it in a var
                Local0 = \_SB.PCI0.LPCB.EC0.TACH(0)
                    
            }
            Else
            {
                // Terminate, return Zero
                Local0 = 0
            }
            
            // Return 255, 0 or Fan RPM based on conditionals above
            Return (Local0)        
        }
        
        Method (TCPU, 0)
        {
            // Add method to handle CPU temperature
            // Check if EC is ready
            If (\_SB.PCI0.LPCB.EC0.ECAV())
            {
                Local0 = \_SB.PCI0.LPCB.EC0.ECPU
                Local1 = 60
                If (Local0 < 128)
                {
                    Local1 = Local0
                }
                
            }
            Else
            {
                // Terminate, return Zero
                Local1 = 0
            }
        
            // Return final CPU temp. ACPISensors take care of the conversion.
            Return (Local1)
        }
        
        // Custom FAN table by black.dragon74 for ASUS machines
        // Quietest fan operation yet coolest CPU.
        // Scaling from values as low as 255 RPM to values as high as 5026 RPM (That's great!)
        // Scaling that ASUS provided was from 2200 RPM to 2900 RPM (Duh!)
        
        // Temperatures. 0xFF means if temp is above 46C, let bios take control of things.
        Name(FTA1, Package()
        {
            32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 0xFF,
        })
        
        // Fan speeds. 255(0xFF) is max, 0(0x00) is for fan off (Not auto)
        Name(FTA2, Package()
        {
            0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 160, 185, 205, 225, 245, 250, 255
        })
        
        // Time out values
        Name (FCTU, 2) // RPM Up
        Name (FCTD, 5) // RPM Down

        // Table to keep track of past temperatures (to track average)
        Name (FHST, Buffer() { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }) // Size should match the count of above FTA1 and FTA2 package
        Name (FIDX, 0) 	// current index in buffer above
        Name (FNUM, 0) 	// number of entries in above buffer to count in avg
        Name (FSUM, 0) 	// current sum of entries in buffer
        
        // Keeps track of last fan speed set, and counter to set new one
        Name (FLST, 0xFF)	// last index for fan control
        Name (FCNT, 0)		// count of times it has been "wrong", 0 means no counter

        // Method to control FAN wrt TEMP
        // Name in ACPIPoller should be FCPU with HID FAN0000
        Method (FCPU, 0)
        {
            // If ICFC is set to 0, terminate
            If (\ANKD.ICFC == 0)
            {
                Return (0)
            }
            
            // If EC is not ready, terminate
            If (!\_SB.PCI0.LPCB.EC0.ECAV())
            {
                Return (0)
            }    
                
            Local5 = \_SB.PCI0.LPCB.EC0.ECPU // Current temperature of the CPU Heatsink
            If (Local5 < 128)
            {
                Local0 = Local5 // Store temperature in Local0
            }
            Else
            {
                Local0 = 60 // As per BIOS
            }    

            // calculate average temperature
            Local1 = Local0 + FSUM
            Local2 = FIDX
            Local1 -= DerefOf(FHST[Local2])
            FHST[Local2] = Local0
            FSUM = Local1  // Local1 is new sum
            
            // adjust current index into temperature history table
            Local2++
            if (Local2 >= SizeOf(FHST)) { Local2 = 0 }
            FIDX = Local2
            
            // adjust total items collected in temp table
            Local2 = FNUM
            if (Local2 != SizeOf(FHST))
            {
                Local2++
                FNUM = Local2
            }
            
            // Local1 is new sum, Local2 is number of entries in sum
            Local0 = Local1 / Local2 // Local0 is now average temp

            // table based search (use avg temperature to search)
            if (Local0 > 255) { Local0 = 255 }
            Local2 = Match(FTA1, MGE, Local0, MTR, 0, 0)

            // calculate difference between current and found index
            if (Local2 > FLST)
            {
                Local1 = Local2 - FLST
                Local4 = FCTU
            }
            else
            {
                Local1 = FLST - Local2
                Local4 = FCTD
            }

            // set new fan speed, if necessary
            if (!Local1)
            {
                // no difference, so leave current fan speed and reset count
                FCNT = 0
            }
            else
            {
                // there is a difference, start/continue process of changing fan
                Local3 = FCNT
                FCNT++
                // how long to wait depends on how big the difference
                // 20 secs if diff is 2, 5 secs if diff is 4, etc.
                Local1 = Local4 / Local1
                if (Local3 >= Local1)
                {
                    // timeout expired, so set new fan speed
                    FLST = Local2
                    \_SB.PCI0.LPCB.EC0.ST98 (DerefOf(FTA2[Local2]))
                    FCNT = 0
                }
            }
            
            Return (1) // Return something as this is a requirement of a ACPI Method
        }    
                         
    } 
    
    // Inject proper USB config for A555LA
    // Change this config with accordance to your USB ports
    // USBInjectAll.kext (RehabMan) is a must have
    Device (UIAC)
    {
        Name (_HID, "UIA00000")
        // So that UIAC is not turned off on machines other than A555LA
        Name (_STA, 1)
        // If A555LA, inject custom USB mappings
        If (\ANKD.IUSB == 1)
        {
            Name (RMCF, Package ()
            {
                "XHC", 
                Package (0x04)
                {
                    "port-count", 
                    Buffer (0x04)
                    {
                         0x0D, 0x00, 0x00, 0x00                         
                    }, 

                    "ports", 
                    Package (0x10)
                    {
                        "HS01", 
                        Package (0x04)
                        {
                            "UsbConnector", 
                            0x03, 
                            "port", 
                            Buffer (0x04)
                            {
                                 0x01, 0x00, 0x00, 0x00                         
                            }
                        }, 

                        "HS02", 
                        Package (0x04)
                        {
                            "UsbConnector", 
                            0x03, 
                            "port", 
                            Buffer (0x04)
                            {
                                 0x02, 0x00, 0x00, 0x00                         
                            }
                        }, 

                        "HS03", 
                        Package (0x04)
                        {
                            "UsbConnector", 
                            Zero, 
                            "port", 
                            Buffer (0x04)
                            {
                                 0x03, 0x00, 0x00, 0x00                         
                            }
                        }, 

                        "HS05", 
                        Package (0x04)
                        {
                            "UsbConnector", 
                            0xFF, 
                            "port", 
                            Buffer (0x04)
                            {
                                 0x05, 0x00, 0x00, 0x00                         
                            }
                        }, 

                        "HS06", 
                        Package (0x04)
                        {
                            "UsbConnector", 
                            0xFF, 
                            "port", 
                            Buffer (0x04)
                            {
                                 0x06, 0x00, 0x00, 0x00                         
                            }
                        }, 

                        "HS08", 
                        Package (0x04)
                        {
                            "UsbConnector", 
                            0xFF, 
                            "port", 
                            Buffer (0x04)
                            {
                                 0x08, 0x00, 0x00, 0x00                         
                            }
                        }, 

                        "SSP1", 
                        Package (0x04)
                        {
                            "UsbConnector", 
                            0x03, 
                            "port", 
                            Buffer (0x04)
                            {
                                 0x0A, 0x00, 0x00, 0x00                         
                            }
                        }, 

                        "SSP2", 
                        Package (0x04)
                        {
                            "UsbConnector", 
                            0x03, 
                            "port", 
                            Buffer (0x04)
                            {
                                 0x0B, 0x00, 0x00, 0x00                         
                            }
                        }
                    }
                }
            })
        }
    }                              
}