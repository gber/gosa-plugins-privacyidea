<?php

/*
 * This code is an addon for GOsa² (https://gosa.gonicus.de)
 * https://github.com/gosa-project/gosa-plugins-privacyidea/
 * Copyright (C) 2023 Daniel Teichmann <daniel.teichmann@das-netzwerkteam.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

require_once(dirname(__FILE__) . "/interfaces/interface_MFAToken.inc");

class MFAUnknownToken implements MFAToken
{
    public function __construct(&$mfaAccount)
    {
    }

    public function renderSetup()
    {
        die("Functions of MFAUnknownToken should not be called!!!");

        return false;
    }

    public function getRenderSetupResult()
    {
        die("Functions of MFAUnknownToken should not be called!!!");
        return "UNKNOWN";
    }

    public function getNextPhaseNumber()
    {
        die("Functions of MFAUnknownToken should not be called!!!");
        return "UNKNOWN";
    }

    public function getSetupCardIcon()
    {
        die("Functions of MFAUnknownToken should not be called!!!");
        return "UNKNOWN";
    }

    public function getSetupCardTitle()
    {
        die("Functions of MFAUnknownToken should not be called!!!");
        return "UNKNOWN";
    }

    public function getSetupCardDescription()
    {
        die("Functions of MFAUnknownToken should not be called!!!");
        return "UNKNOWN";
    }

    public function getSetupCardButtonText()
    {
        die("Functions of MFAUnknownToken should not be called!!!");
        return "UNKNOWN";
    }
}