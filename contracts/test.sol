// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
/*
 * @title CoinFlip - Basit Yazı-Tura Oyunu
 * @dev Kullanıcılar her oyun için 0.0000035 ETH öder (~$0.01 USD @ 3000 USD/ETH)
 * Kazanma/kaybetme önemli değil - para kontratta birikir
 */
contract CoinFlip {
    address public owner;
    uint256 public constant GAME_FEE = 0.000000035 ether; // ~$0.01 USD
    uint256 public totalGamesPlayed;
    uint256 public totalFeesCollected;
    
    // Oyun sonuçları için event
    event GamePlayed(
        address indexed player,
        bool playerChoice, // true = Heads (Yazı), false = Tails (Tura)
        bool result,       // Gerçek sonuç
        bool won,          // Kazandı mı?
        uint256 gameNumber
    );
    
    event FundsWithdrawn(address indexed owner, uint256 amount);
    
    constructor() {
        owner = msg.sender;
    }
    
    /
     * @dev Yazı-tura oyunu oyna
     * @param _choice true = Yazı (Heads), false = Tura (Tails)
     */
    function play(bool _choice) external payable {
        require(msg.value >= GAME_FEE, "Must send at least 0.0000035 ETH to play");
        
        // Rastgele sonuç üret
        bool result = _generateRandomResult();
        
        // Kullanıcı kazandı mı kontrol et
        bool won = (_choice == result);
        
        // Kazansa da kaybetse de para kontratta kalır
        totalGamesPlayed++;
        totalFeesCollected += msg.value;
        
        emit GamePlayed(msg.sender, _choice, result, won, totalGamesPlayed);
    }
    
    /
     * @dev Rastgele sonuç üret (basit versiyon)
     */
    function _generateRandomResult() private view returns (bool) {
        uint256 random = uint256(
            keccak256(
                abi.encodePacked(
                    block.timestamp,
                    block.prevrandao,
                    msg.sender,
                    totalGamesPlayed
                )
            )
        );
        return (random % 2 == 0);
    }
    
    /
     * @dev Kontratta toplanan ETH miktarını görüntüle
     */
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
    
    /
     * @dev Kontrattan toplanan paraları çek (sadece owner)
     */
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds to withdraw");
        
        payable(owner).transfer(balance);
        emit FundsWithdrawn(owner, balance);
    }
    
    /
     * @dev Oyun istatistiklerini görüntüle
     */
    function getStats() external view returns (
        uint256 gamesPlayed,
        uint256 feesCollected,
        uint256 currentBalance
    ) {
        return (
            totalGamesPlayed,
            totalFeesCollected,
            address(this).balance
        );
    }
}