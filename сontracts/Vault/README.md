\# Papa Vault



Papa Vault — учебный DeFi-проект на базе стандарта ERC-4626.



Контракт представляет собой токенизированное хранилище, в которое пользователь может внести токены PVT и получить взамен долю хранилища в виде vPVT.



Проект развёрнут и протестирован в сети Base.



\## Контракты



\### PapaVaultToken.sol



Базовый ERC-20 токен, который используется как актив хранилища.



Параметры:



\- Name: Papa Vault Token

\- Symbol: PVT

\- Initial supply: 1,000,000 PVT

\- Decimals: 18



Адрес контракта:



```text

0x61cA1783Df12d3d253D8985fb815630B1989f7EF

PapaVault.sol



ERC-4626 Vault, который принимает PVT и выпускает токены доли vPVT.



Адрес контракта:



0x1bBBa8C651eEEbb8ccD89df2610fdc168E160cF5

Основные возможности

внесение PVT через deposit

выпуск долей через mint

вывод PVT через withdraw

погашение долей через redeem

конвертация между активами и долями

ограничение общего объёма хранилища

временная остановка операций

управление ролями

защита от повторного входа

Использованные стандарты и модули



Проект использует OpenZeppelin Contracts:



ERC20

ERC4626

AccessControl

Pausable

ReentrancyGuard

Роли



Контракт использует следующие роли:



DEFAULT\_ADMIN\_ROLE — управление ролями

PAUSER\_ROLE — остановка и возобновление работы Vault

MANAGER\_ROLE — изменение лимита Vault

Vault Cap



Контракт содержит переменную vaultCap, которая ограничивает максимальное количество PVT, находящихся в хранилище.



Менеджер может изменить лимит функцией:



setVaultCap(uint256 newVaultCap)



Функции maxDeposit и maxMint автоматически учитывают установленный лимит.



Как работает Vault



Перед внесением токенов пользователь должен разрешить Vault использовать его PVT:



approve(vaultAddress, amount)



После этого можно внести активы:



deposit(amount, receiver)



Vault переводит PVT на свой баланс и выпускает пользователю соответствующее количество vPVT.



Для вывода активов доступны два варианта:



withdraw(assets, receiver, owner)



или:



redeem(shares, receiver, owner)

Тестирование



В Remix были успешно проверены:



deployment PapaVaultToken

deployment PapaVault

approve

deposit

withdraw

redeem

totalAssets

totalSupply

balanceOf

pause

блокировка deposit во время паузы

unpause

восстановление deposit после снятия паузы

setVaultCap

maxDeposit

Пример теста



Пользователь внёс:



100 PVT



И получил:



100 vPVT



После вывода 50 PVT:



totalAssets = 50 PVT

totalSupply = 50 vPVT



После погашения 10 vPVT пользователь получил обратно 10 PVT.



Технологии

Solidity 0.8.24

OpenZeppelin Contracts

Remix IDE

MetaMask

Base

Blockscout

Статус



Проект завершён.



Основная логика ERC-4626 и дополнительные функции управления успешно протестированы.

