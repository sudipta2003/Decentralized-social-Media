TwitterDapp

A decentralized Twitter-like application where users can post and retrieve tweets directly on the blockchain. This DApp allows users to express their thoughts and ideas while maintaining ownership of their data in a decentralized manner.
Vision

The vision of TwitterDapp is to create a decentralized social media platform where users can freely post content without the fear of censorship, while ensuring that their data remains secure and immutable on the blockchain. We aim to empower individuals with control over their own digital presence in a transparent and decentralized environment.
Smart Contract Flow

mermaid

graph TD;
    User -->|posts tweet| Contract[Smart Contract];
    Contract -->|stores tweet| Blockchain;
    User -->|fetches tweet| Contract;
    Contract -->|returns tweet data| User;

Features

    Post a Tweet: Users can post tweets that are stored immutably on the blockchain.
    View Tweets: Anyone can retrieve all posted tweets.
    Decentralization: All data is stored on the blockchain, ensuring no central authority controls the content.

Smart Contract

solidity

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TwitterDapp {
    struct Tweet {
        address user;
        string content;
        uint timestamp;
    }

    Tweet[] public tweets;

    function postTweet(string memory content) public {
        tweets.push(Tweet({
            user: msg.sender,
            content: content,
            timestamp: block.timestamp
        }));
    }

    function getTweets() public view returns (Tweet[] memory) {
        return tweets;
    }
}

Contract Address

The smart contract is deployed on the Ethereum network at the following address:

[0x08601Fa4241b63d05eA9d9e5336F83631346BB82]
Future Scope

    User Profiles: Allow users to create profiles with additional information like bio, profile picture, etc.
    Tweet Replies and Retweets: Add functionality for users to reply and retweet existing posts.
    Reputation System: Introduce a reputation mechanism to highlight quality content.
    Likes and Comments: Implement a system where users can interact with tweets via likes and comments.
    IPFS Integration: Store larger files like images and videos using IPFS and link them to the tweets.
    Mobile Application: Build a mobile app version of TwitterDapp to reach a wider audience.

How to Use

    Install MetaMask or another compatible Ethereum wallet.
    Connect your wallet to the Ethereum network.
    Interact with the smart contract through the TwitterDapp front-end interface.

Contact Information

For any inquiries, suggestions, or issues, feel free to reach out:

Project Owner:
Name: Sudipta parasar
Email: sudiptaparasar42@gmail.com
GitHub: https://github.com/sudipta2003/
License

This project is licensed under the MIT License.
