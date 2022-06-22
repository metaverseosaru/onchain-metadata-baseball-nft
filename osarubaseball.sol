// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import { ERC721A } from "erc721a/contracts/ERC721A.sol";

contract OsaruBaseball is ERC721A, Ownable {
    mapping(string => bool) private takenNames;
    mapping(uint256 => Attr) public attributes;

    struct Attr {
        string name;
        string imageURI;
        uint8 contact;
        uint8 power;
        uint8 run; 
        uint8 throwing; 
        uint8 defence; 
    }

    constructor() ERC721A("Osaru Baseball", "OBB") {}

    function mint(string memory _name) public {
        _safeMint(_msgSender(), 1);
        uint8 _contact  = uint8(uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, "contact"))))%100;
        uint8 _power    = uint8(uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, "power"))))%100;
        uint8 _run      = uint8(uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, "run"))))%100;
        uint8 _throwing = uint8(uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, "throwing"))))%100;
        uint8 _defence  = uint8(uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, "defence"))))%100;
        uint256 tokenId = _totalMinted()-1; 
        attributes[tokenId] = Attr(_name, "https://gateway.pinata.cloud/ipfs/QmU6Gda4JE2Kw3sYs3VHdj19QFk9tCVbYzX7TBy13w3rmw", _contact, _power, _run, _throwing, _defence);
    }

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory) {
        string memory json = Base64.encode(
            bytes(string(
                abi.encodePacked(
                    '{"name": "', attributes[tokenId].name, '",',
                    '"image": "', attributes[tokenId].imageURI, '",',
                    '"attributes": [{"trait_type": "Contact", "max_value": 100, "value": ', uint2str(attributes[tokenId].contact), '},',
                    '{"trait_type": "Power", "max_value": 100, "value": ', Strings.toString(attributes[tokenId].power), '},',
                    '{"trait_type": "Base Running", "max_value": 100, "value": ', Strings.toString(attributes[tokenId].run), '},',
                    '{"trait_type": "Throwing", "max_value": 100, "value": ', Strings.toString(attributes[tokenId].throwing), '},',
                    '{"trait_type": "Defence", "max_value": 100, "value": ', Strings.toString(attributes[tokenId].defence), '}',
                    ']}'
                )
            ))
        );
        return string(abi.encodePacked('data:application/json;base64,', json));
    }    
}