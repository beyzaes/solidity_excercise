// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ZodiacTokenRecommender {
    // Struct to hold token recommendation details
    struct TokenRecommendation {
        string tokenName;
        string description;
        uint256 luckFactor; // A random multiplier (1-100) for fun
        uint256 recommendedAt; // Timestamp of recommendation
    }

    // Mapping of wallet to their latest recommendation
    mapping(address => TokenRecommendation) public recommendations;

    // Zodiac-inspired tokens (12 tokens, one per zodiac sign)
    string[12] private tokenNames = [
        "FireCoin",      // Aries
        "EarthToken",    // Taurus
        "AirBucks",      // Gemini
        "CrabCoin",      // Cancer
        "LionToken",     // Leo
        "HarvestCoin",   // Virgo
        "BalanceBucks",  // Libra
        "ScorpioToken",  // Scorpio
        "ArcherCoin",    // Sagittarius
        "MountainToken", // Capricorn
        "AquaToken",     // Aquarius
        "FishCoin"       // Pisces
    ];

    string[12] private tokenDescriptions = [
        "A fiery token for bold risk-takers!",                    // Aries
        "A stable token for grounded investors.",                 // Taurus
        "A versatile token for quick thinkers.",                  // Gemini
        "A nurturing token with emotional value.",                // Cancer
        "A regal token for those who lead.",                     // Leo
        "A precise token for analytical minds.",                  // Virgo
        "A harmonious token for balanced portfolios.",            // Libra
        "A mysterious token with deep potential.",                // Scorpio
        "An adventurous token for explorers.",                    // Sagittarius
        "A sturdy token for ambitious climbers.",                 // Capricorn
        "An innovative token for visionaries.",                   // Aquarius
        "A fluid token for dreamy investors."                     // Pisces
    ];

    // Event emitted when a recommendation is made
    event TokenRecommended(
        address indexed wallet,
        string tokenName,
        string description,
        uint256 luckFactor,
        uint256 recommendedAt
    );

    // Function to recommend a token based on wallet address
    function recommendToken() external returns (TokenRecommendation memory) {
        // Calculate zodiac index (0-11) based on wallet address
        uint256 zodiacIndex = uint256(keccak256(abi.encodePacked(msg.sender))) % 12;

        // Generate a pseudo-random luck factor (1-100) based on wallet and block
        uint256 luckFactor = (uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp, block.number))) % 100) + 1;

        // Create recommendation
        TokenRecommendation memory recommendation = TokenRecommendation({
            tokenName: tokenNames[zodiacIndex],
            description: tokenDescriptions[zodiacIndex],
            luckFactor: luckFactor,
            recommendedAt: block.timestamp
        });

        // Store recommendation
        recommendations[msg.sender] = recommendation;

        // Emit event
        emit TokenRecommended(
            msg.sender,
            recommendation.tokenName,
            recommendation.description,
            recommendation.luckFactor,
            recommendation.recommendedAt
        );

        return recommendation;
    }

    // Function to get a wallet's latest recommendation
    function getRecommendation(address wallet) external view returns (TokenRecommendation memory) {
        require(recommendations[wallet].recommendedAt != 0, "No recommendation found for this wallet");
        return recommendations[wallet];
    }

    // Function to get all possible tokens (for frontend or curiosity)
    function getAllTokens() external view returns (string[12] memory, string[12] memory) {
        return (tokenNames, tokenDescriptions);
    }
}