// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FlowerTokenRecommender {
    // Struct to hold token recommendation details
    struct TokenRecommendation {
        string tokenName;
        string description;
        uint256 luckFactor; // A random multiplier (1-100) for fun
        uint256 recommendedAt; // Timestamp of recommendation
    }

    // Mapping of wallet to their latest recommendation
    mapping(address => TokenRecommendation) public recommendations;

    // Flower-inspired tokens (12 tokens, one per zodiac sign)
    string[12] private tokenNames = [
        "RoseCoin",       // Aries
        "TulipToken",     // Taurus
        "LavenderBucks",  // Gemini
        "LilyCoin",       // Cancer
        "SunflowerToken", // Leo
        "DaisyCoin",      // Virgo
        "OrchidBucks",    // Libra
        "LotusToken",     // Scorpio
        "JasmineCoin",    // Sagittarius
        "PansyToken",     // Capricorn
        "IrisCoin",       // Aquarius
        "PeonyBucks"      // Pisces
    ];

    string[12] private tokenDescriptions = [
        "A passionate token for bold leaders!",                     // Aries (Rose)
        "A grounded token for patient investors.",                  // Taurus (Tulip)
        "A calming token for adaptable minds.",                     // Gemini (Lavender)
        "A nurturing token for emotional connections.",             // Cancer (Lily)
        "A vibrant token for confident creators.",                  // Leo (Sunflower)
        "A precise token for analytical planners.",                  // Virgo (Daisy)
        "A balanced token for harmonious portfolios.",              // Libra (Orchid)
        "A transformative token with hidden potential.",            // Scorpio (Lotus)
        "An adventurous token for free spirits.",                   // Sagittarius (Jasmine)
        "A resilient token for disciplined builders.",              // Capricorn (Pansy)
        "An innovative token for forward thinkers.",                // Aquarius (Iris)
        "A dreamy token for intuitive investors."                   // Pisces (Peony)
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
        // Calculate flower index (0-11) based on wallet address
        uint256 flowerIndex = uint256(keccak256(abi.encodePacked(msg.sender))) % 12;

        // Generate a pseudo-random luck factor (1-100) based on wallet and block
        uint256 luckFactor = (uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp, block.number))) % 100) + 1;

        // Create recommendation
        TokenRecommendation memory recommendation = TokenRecommendation({
            tokenName: tokenNames[flowerIndex],
            description: tokenDescriptions[flowerIndex],
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