{******************************************************************************}
{                                                                              }
{                         Portable Executable Flags                            }
{                                                                              }
{  Данный включаемый файл содержит Microsoft PE флаги.                         }
{  Включение данного файла производится непосредственно в файле проекта.       }
{  Для компиляции необходимо подключение модуля Windows.                       }
{                                                                              }
{                       Copyright © 2010 by Xcentric                           }
{                                                                              }
{******************************************************************************}

// EXE file size reducing:
{$SetPEFlags IMAGE_FILE_RELOCS_STRIPPED Or IMAGE_FILE_DEBUG_STRIPPED Or
  IMAGE_FILE_LINE_NUMS_STRIPPED Or IMAGE_FILE_LOCAL_SYMS_STRIPPED}

// Running from swap:
{.$SetPEFlags IMAGE_FILE_REMOVABLE_RUN_FROM_SWAP Or IMAGE_FILE_NET_RUN_FROM_SWAP}

// Application can handle addresses larger than 2 GB:
{.$SetPEFlags IMAGE_FILE_LARGE_ADDRESS_AWARE}

// Reducing the use of physical memory by forcing the flush of application data to swap:
{.$SetPEFlags IMAGE_FILE_AGGRESIVE_WS_TRIM}

// Mark output EXE file as system:
{.$SetPEFlags IMAGE_FILE_SYSTEM}