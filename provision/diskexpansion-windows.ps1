  # Automate the diskexpansion within the win11 guest
    # Get the maximum size supported by the partition and resize it
    $drive = Get-PartitionSupportedSize -DriveLetter C
    Resize-Partition -DriveLetter C -Size $drive.SizeMax
