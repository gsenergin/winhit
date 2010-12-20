{******************************************************************************}
{                                                                              }
{                            UNIT WMI.Constants                                }
{                                                                              }
{  Данный модуль содержит константы для работы с WMI.                          }
{                                                                              }
{                       Copyright © 2010 by Xcentric                           }
{                                                                              }
{http://code.google.com/p/powered-by-delphi/                                   }
{******************************************************************************}

{

  ИСТОРИЯ ВЕРСИЙ / VERSION HISTORY:

  (1.0 | XX.XX.2010)
    Первый релиз модуля.
    First unit release.

}

unit WMI.Constants;

interface

const

  { WMIBase.pas }

  STR_WMI_DEFAULT_HOST      = '.';
  STR_WMI_DEFAULT_NAMESPACE = 'root\CIMV2';
  STR_WMI_DEFAULT_USER      = '';
  STR_WMI_DEFAULT_PASSWORD  = '';

  { WQL.pas }

  STR_WMI_QUERYLANG = 'WQL';
  CHR_WQL_PROPS_SEPARATOR = ',';

resourcestring

  { WMIExceptions.pas }

  SAlreadyConnected = 'Already connected to the specified WMI service.';
  SConnectFailed = 'Unable to connect to the specified WMI service on ' +
                   'server "%s" and namespace "%s" with username "%s" and ' +
                   'password "%s".' + {exception info} '%s';
  SClassNotFound = 'Unable to retrieve class "%s".' + {exception info} '%s';
  SParamIsReadOnlyWhileConnected = 'Unable to change this parameter while' +
                                   'connected to the WMI service.';
  SQueryFailed = 'Error while executing query "%s".' + {exception info} '%s';

implementation

end.
