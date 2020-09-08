#requires -version 3
# Add forms to Powershell
Add-Type -assembly System.Windows.Forms
$main_form = New-Object System.Windows.Forms.Form
$main_form.Text ='GUI Test'
$main_form.Width = 600
$main_form.Height = 400
$main_form.AutoSize = $true
# Add label
$Label = New-Object System.Windows.Forms.Label
$Label.Text = "Test Label 1"
$Label.Location  = New-Object System.Drawing.Point(0,10)
$Label.AutoSize = $true
$main_form.Controls.Add($Label)
# Add combo box
$ComboBox = New-Object System.Windows.Forms.ComboBox
$ComboBox.Width = 300
$Users = get-localuser -name *
Foreach ($User in $Users) {
    $ComboBox.Items.Add($User);
}
$ComboBox.Location  = New-Object System.Drawing.Point(60,10)
$main_form.Controls.Add($ComboBox)
# Add Label 2
$Label2 = New-Object System.Windows.Forms.Label
$Label2.Text = "Test Label 2"
$Label2.Location  = New-Object System.Drawing.Point(0,40)
$Label2.AutoSize = $true
$main_form.Controls.Add($Label2)
# Add Label 3 
$Label3 = New-Object System.Windows.Forms.Label
$Label3.Text = "Test Label 3"
$Label3.Location  = New-Object System.Drawing.Point(110,40)
$Label3.AutoSize = $true
$main_form.Controls.Add($Label3)

$TestThing = New-Object System.Windows.Forms.Button
$TestThing.Text = "Button 1"
$TestThing.Name = "Name 1"


#Show The Dialog
$main_form.ShowDialog()