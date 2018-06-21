$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
#. "$here\utilities.Tattoo.psm1"
Import-module "..\.\PowershellClassUtils.psm1" -Force

Describe "Testing Get-ClassProperty"{
    
    InModuleScope PowershellClassUtils {


        $TestCaseClass = @'
        Class Woop {
            [String]$String
            [int]$number
        
            Woop(){
    
            }
    
            Woop([String]$String,[int]$Number){
        
            }
        
            [String]DoSomething(){
                return $this.String
            }
        }
        
        Class Wap :Woop {
            [String]$prop3
        
            DoChildthing(){}
            [int]DoChildthing2(){
                return 3
            }
            DoChildthing3([int]$Param1,[bool]$Param2){
                #Does stuff
            }
            [Bool] DoChildthing4([String]$MyString,[int]$MyInt,[DateTime]$MyDate){
                return $true
            }
            
        
        }
        
        Class Wep : Woop {
            [String]$prop4
        
            DoOtherChildThing(){
        
            }
        }
'@
    

        $ClassScript = Join-Path -Path $Testdrive -ChildPath "WoopClass.ps1"
        $TestCaseClass | Out-File -FilePath $ClassScript -Force
        . $ClassScript
        
        

        it 'Should Return 2 Properties' {


            (Get-ClassProperties -ClassName "Woop" | measure).Count | should be 2
        }

        Context 'Validating Properties' {
            $Properties = @("String","Number")
            $methods = Get-ClassProperties -ClassName "Wap"
            foreach ($prop in $Properties){

                it "Should have Property: $($Prop)" {
                    ($methods | gm).Name -contains $prop
                }
            }

        }

    }
    
        
    
}