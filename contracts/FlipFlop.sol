    // SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CoinFlip - Ücretsiz (sadece gas) Yazı-Tura (geliştirilmiş)
/// @dev Demo amaçlı; üretimde rastgelelik için VRF kullanın (Chainlink vb.)
contract CoinFlip {
    /* ========== ERRORS ========== */
    error NotOwner();
    error NoFunds();
    error TransferFailed();

    /* ========== STATE ========== */
    address payable public owner; //owner
    uint256 public totalGamesPlayed;
    uint256 private _nonce; // ekstra değişken rastgelelikleri biraz çeşitlendirmek için (yeterince güvenli değildir)

    /* ========== EVENTS ========== */
    event GamePlayed(
        address indexed player,
        bool playerChoice, // true = Yazı (Heads), false = Tura (Tails)
        bool result,       // Gerçek sonuç
        bool won,          // Kazandı mı?
        uint256 gameNumber
    );

    event FundsWithdrawn(address indexed owner, uint256 amount);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /* ========== CONSTRUCTOR ========== */
    constructor() {
        owner = payable(msg.sender);
        emit OwnershipTransferred(address(0), owner);
    }

    /* ========== MODIFIERS ========== */
    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    /* ========== PUBLIC / EXTERNAL FUNCTIONS ========== */

    /// @notice Yazı-tura oyna (ücretsiz: sadece gas)
    /// @param _choice true = Yazı (Heads), false = Tura (Tails)
    function play(bool _choice) external {
        bool result = _generateRandomResult();
        bool won = (_choice == result);

        totalGamesPlayed++;
        emit GamePlayed(msg.sender, _choice, result, won, totalGamesPlayed);
    }

    /// @notice Kontrat bakiyesi
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /// @notice Owner sadece çekebilir (bağışlar için)
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        if (balance == 0) revert NoFunds();

        // checks-effects-interactions: burada state yok ama call kullanıyoruz -> güvenlik
        (bool sent, ) = owner.call{value: balance}("");
        if (!sent) revert TransferFailed();

        emit FundsWithdrawn(owner, balance);
    }

    /// @notice Sahip değişikliği
    function transferOwnership(address payable newOwner) external onlyOwner {
        require(newOwner != address(0), "zero address");
        address previous = owner;
        owner = newOwner;
        emit OwnershipTransferred(previous, newOwner);
    }

    /* ========== RECEIVE & FALLBACK ========== */
    /// @notice Bağış / tip alabilmek için
    receive() external payable {}
    fallback() external payable {}

    /* ========== VIEWS / HELPERS ========== */

    /// @dev Basit rastgelelik (DEMONSTRASYON İÇİN; ÜRETİMDE GÜVENLİ DEĞİL)
    /// @notice Bu fonksiyon güvenli rastgelelik sağlamaz. Chainlink VRF gibi dış servisleri kullanın.
    function _generateRandomResult() private view returns (bool) {
        // Not: block.prevrandao ve block.timestamp manipüle edilebilir.
        uint256 random = uint256(
            keccak256(
                abi.encodePacked(
                    block.timestamp,
                    block.prevrandao,
                    msg.sender,
                    totalGamesPlayed,
                    _nonce // state okunuyor ama private; burayı yazma için fonksiyon view olduğundan _nonce değişmiyor
                )
            )
        );
        return (random % 2 == 0);
    }

    /* ========== OPTIONAL: güvenlik notu ==========
       - Bu kontrat demo amaçlıdır. Rastgelelik saldırılara açıktır.
       - Eğer bahis (stake) eklenecekse: kullanıcının yatırdığı miktar kontratta tutulacak ve kazanan/ kaybeden mantığı ile dağıtım yapılacak.
       - Gerçek dünyada Chainlink VRF veya başka güvenli oracle kullanın.
    */
}