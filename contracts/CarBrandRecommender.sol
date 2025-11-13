// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CarBrandTokenRecommender {
    // Struct to hold token recommendation details
    struct TokenRecommendation {
        string tokenName;
        string description;
        uint256 luckFactor; // A random multiplier (1-100) for fun
        uint256 recommendedAt; // Timestamp of recommendation
    }

    // Mapping of wallet to their latest recommendation
    mapping(address => TokenRecommendation) public recommendations;

    // Car brand-inspired tokens (12 tokens)
    string[12] private tokenNames = [
        "FerrariCoin",     // Aries
        "MercedesToken",   // Taurus
        "TeslaBucks",      // Gemini
        "BMWCoin",         // Cancer
        "LamborghiniToken",// Leo
        "AudiCoin",        // Virgo
        "PorscheBucks",    // Libra
        "BugattiToken",    // Scorpio
        "FordCoin",        // Sagittarius
        "ToyotaToken",     // Capricorn
        "HondaCoin",       // Aquarius
        "JeepBucks"       // Pisces
    ];

    string[12] private tokenDescriptions = [
        "A high-performance token for speed enthusiasts!",                     // Aries (Ferrari)
        "A luxurious token for sophisticated investors.",                    // Taurus (Mercedes)
        "An innovative token for tech-savvy futurists.",                      // Gemini (Tesla)
        "A reliable token for emotional security seekers.",                   // Cancer (BMW)
        "A flashy token for confident trendsetters.",                         // Leo (Lamborghini)
        "A precise token for detail-oriented planners.",                      // Virgo (Audi)
        "A high-value token for balanced portfolios.",                        // Libra (Porsche)
        "An exclusive token with transformative potential.",                  // Scorpio (Bugatti)
        "A versatile token for adventurous spirits.",                        // Sagittarius (Ford)
        "A dependable token for long-term builders.",                        // Capricorn (Toyota)
        "An efficient token for practical innovators.",                      // Aquarius (Honda)
        "A rugged token for intuitive explorers."                            // Pisces (Jeep)
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
        // Calculate car brand index (0-11) based on wallet address
        uint256 carIndex = uint256(keccak256(abi.encodePacked(msg.sender))) % 12;

        // Generate a pseudo-random luck factor (1-100) based on wallet and block
        uint256 luckFactor = (uint256(keccak256(abi.encodePacked(msg.sender, block.timestamp, block.number))) % 100) + 1;

        // Create recommendation
        TokenRecommendation memory recommendation = TokenRecommendation({
            tokenName: tokenNames[carIndex],
            description: tokenDescriptions[carIndex],
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