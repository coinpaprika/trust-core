// Copyright © 2017-2018 Trust.
//
// This file is part of Trust. The full Trust copyright notice, including
// terms governing use, modification, and redistribution, is contained in the
// file LICENSE at the root of the source code distribution tree.

import TrustCore
import XCTest

class DashAddressTests: XCTestCase {
    func testAddress() {
        let privateKey = PrivateKey(wif: "XDoxFwfxsEZDd15uNyj8vt64c3GLxcFjTefnUz7gckvAJeYSFaRz")!
        let publicKey = privateKey.publicKey(compressed: true)
        let address = Dash().address(for: publicKey)

        XCTAssertEqual(address.description, "Xw7HTXGY3TFeA3ZsVuMRrYh96GtwWb4hQb")
    }

    func testExtendedKeys() {
        let wallet = HDWallet(mnemonic: "ripple scissors kick mammal hire column oak again sun offer wealth tomorrow wagon turn fatal", passphrase: "TREZOR")

        let xprv = wallet.getExtendedPrivateKey(for: .bip44, coin: .dash, version: .xprv)
        let xpub = wallet.getExtendedPubKey(for: .bip44, coin: .dash, version: .xpub)

        XCTAssertEqual(xprv, "xprv9zSMAfz7nQUZDQXMifsT5Cbss1Kh8XgnsKsrFfx83bvbuubs6ra84k95XMpAJmt51jymfNrXid81bu9tUTW2W2g7CBU5e6F297XBuXfSmjJ")
        XCTAssertEqual(xpub, "xpub6DRhaBX1cn2rRtbpphQTSLYcR3ABXzQeEYoT44MjbwTanhw1ePtNcYTZNeHyrJMsMGTbig4iFMSvht7RviohzFxkpjURgHDThygLqbZ1tib")
    }

    func testDeriveFromXPub() {
        let xpub = "xpub6DRhaBX1cn2rRtbpphQTSLYcR3ABXzQeEYoT44MjbwTanhw1ePtNcYTZNeHyrJMsMGTbig4iFMSvht7RviohzFxkpjURgHDThygLqbZ1tib"
        let bc = Dash()
        let xpubAddr2 = bc.derive(from: xpub, at: bc.derivationPath(account: 0, change: 1, at: 2))!
        let xpubAddr9 = bc.derive(from: xpub, at: bc.derivationPath(account: 0, change: 1, at: 9))!

        XCTAssertEqual(xpubAddr2.description, "Xh4D3Mv6ikL5iR45bEsCtaR8Ub4jkRLpU2")
        XCTAssertEqual(xpubAddr9.description, "XvwNJsXVBpvAU92xPwU8phT6wKjJVaBMkk")
    }

    func testLockScript() {
        let dash = Dash()
        let address = DashAddress(string: "XrQdeH6THeUsWT9pjLBCACiY6PYnXpR9qA")!
        let address2 = DashAddress(string: "XsuadBD6Q5mVbSKbB6ud1jd6ta3qsbooSq")!
        let script = dash.buildScript(for: address)!
        let script2 = dash.buildScript(for: address2)!

        XCTAssertEqual(script.data.hexString, "76a914ac712e9df2a955b1399a57e0e41379a7b811669d88ac")
        XCTAssertEqual(script2.data.hexString, "76a914bce2d9c3f8af21b82e6a3ee11c3a900c6fe9513788ac")
    }

}
