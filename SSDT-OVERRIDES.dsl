// Copyright: black.dragon74
// IMPORTANT: If you use sorted order, this SSDT should load immediately after OEM SSDTs

// This SSDT is used to disable bogus devices that are not needed by macOS
// This SSDT also injects new devices according to original Apple Laptops

// Before using this SSDT make sure you remove any conflicting Name or Method properties from your native ACPI tables

// Meant specifically for ASUS A555LA, but, might work for other laptops
// _STA to XSTA renames required in DSDT & SSDTs: DptfTabl, CpccTabl, SaSSDT

// TODO: What this ssdt does
    
DefinitionBlock("SSDT-OVERRIDES", "SSDT", 2, "Nick", "AsusOpt", 0)
{

    External (B1B2, MethodObj)
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
    External (\_SB.PCI0.LPCB.ADBG, DeviceObj)
    External (\_SB.PCI0.LPCB.CWDT, DeviceObj)
    External (\_SB.PCI0.LPCB.DMAC, DeviceObj)
    External (_SB_.PCI0.LPCB.EC0_.AH00, FieldUnitObj)
    External (_SB_.PCI0.LPCB.EC0_.AH01, FieldUnitObj)
    External (_SB_.PCI0.LPCB.EC0_.TAH0, FieldUnitObj) // If the battery fix is not applied import 16 bit register
    External (\_SB.PCI0.LPCB.FWHD, DeviceObj)
    External (\_SB.PCI0.LPCB.IPIC, DeviceObj)
    External (\_SB.PCI0.LPCB.LDRC, DeviceObj)
    External (\_SB.PCI0.LPCB.TIMR, DeviceObj)
    External (\_SB.PCI0.RP03, DeviceObj)
    External (\_SB.PCI0.RP04, DeviceObj)
    External (\_SB.PCI0.PDRC, DeviceObj)
    External (\_SB.PCI0.SBUS, DeviceObj)
    External (\_SB.PCI0.TPCH, DeviceObj)
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
        Name (BFXD, 1) // Set this to 0 if you have not applied the battery fix (Split registers larger than 8 bytes)
        Name (AUDL, 3) // Audio layout of your AppleHDA
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
        
        // Renamed _STA to XSTA in SSDT-5 (DptfTabl)
        Scope (IETM)
        {
            Name (_STA, Zero)
        }
        
        // Renamed _STA to XSTA in SSDT-6 (CpccTabl)
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
        // Method _STA renamed to XSTA in SSDT-8 (SaSSDT)
        Scope (B0D3)
        {
            Name (_STA, Zero)
        }
        
        // Disable bogus B0D4 device
        // Method _STA renamed to XSTA in SSDT-5 (DptfTabl)
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
        // Method _STA renamed to XSTA in SSDT-5 (DptfTabl)
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
    Scope (\_SB)
    {
        Device (EC)
        {
            Name (_HID, "EC000000")
        }
    }
            
    Scope (\_SB.PCI0)
    {
        Scope (ADP1)
        {
            Name (_PRW, Package() { 0x18, 0x03 })
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
            Name (_STA, 0x0F) // _STA: Status

            Method (_DSM, 4, NotSerialized)  // _DSM: Device-Specific Method
            {
                If (LEqual (Arg2, Zero))
                {
                    Return (Buffer (One)
                    {
                         0x03                                           
                    })
                }

                Return (Package (0x04)
                {
                    "hda-gfx", 
                    Buffer (0x0A)
                    {
                        "onboard-1"
                    }, 

                    "layout-id", 
                    Buffer (0x04)
                    {
                         0x03, 0x00, 0x00, 0x00                         
                    }
                })
            }
        }
        
        // If your ACPI tables doesn't have HDEF device, uncomment the lines below
        //Device(HDEF)
        //{
        //    Name(_ADR, 0x001b0000)
        //    Name(_PRW, Package() { 0x0d, 0x05 }) // may need tweaking (or not needed)
        //}
        
        // Add audio device properties. Make sure you have renamed conflicting _DSM to XDSM in DSDT
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
        Method (FAN0, 0)
        {
            Local3=2974 // Just to supress warnings
            Store (\ANKD.BFXD, Local2)
            If (Local2 == 1)
            {
                Store (B1B2 (\_SB.PCI0.LPCB.EC0.AH00, \_SB.PCI0.LPCB.EC0.AH01), Local0) // Read value from two 8 bit registers
            }
            ElseIf (Local2 == 0)
            {
                Store (\_SB.PCI0.LPCB.EC0.TAH0, Local0) // Read value from 16bit register
            }
            Else
            {
                Store (0, _STA) // Turn off the device
            }
                    
            If (LEqual (Local0, 0xFF))
            {
                Store (Zero, Local0)
            }

            If (Local0)
            {
                Multiply (Local0, 0x02, Local0)
                Divide (0x0041CDB4, Local0, Local1, Local0)
            }

            If (CondRefOf(Local3))  // Just to supress warning
            {
                Store (Local1, Local3)
            }    
                
            Return (Local0)
        }           
    } 
    
    // Inject proper USB config for A555LA
    // Change this config with accordance to your USB ports
    // USBInjectAll.kext (RehabMan) is a must have
    Device (UIAC)
    {
        Name (_HID, "UIA00000")
        
        // Read value of ANKD.IUSB and turn device on/off accordingly
        Method (_STA, 0)
        {
            Store (\ANKD.IUSB, Local0)
            If (Local0 == 1)
            {
                Return (1)
            }
            Else
            {
                Return (0)
            }                  
        }
        
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