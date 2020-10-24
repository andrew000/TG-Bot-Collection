# PowerShell Telegram Bot
### Author 
GitHub: [AndrewKing](https://github.com/andrew000)

### Dependencies
- Windows 7, 8, 8.1, 10
- PowerShell
___

### Deploy
_open PowerShell and type:_

`./bot.ps1`
___

### Errors

#### [UnauthorizedAccess] Error:
```
+ ./bot.ps1
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : SecurityError: (:) [], ParentContainsErrorRecordException
    + FullyQualifiedErrorId : UnauthorizedAccess
```

#### [UnauthorizedAccess] Solution:

_Execute in Powershell:_

`Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

_After working with the script, return everything as it was_:

`Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope CurrentUser`