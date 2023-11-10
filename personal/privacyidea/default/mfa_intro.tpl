{*
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
 *}
<h2>{t}Multifactor authentication requirements{/t}</h2>
<div class="row">
    <p>
        {t}Multifactor authentication protects your account from unauthorized access.{/t}
        {t}The current configuration for this account is that the use of MFA is {/t}
        <b>
            {if $mfaRequired}
                {t}required{/t}
            {else}
                {t}not required{/t}
            {/if}
        </b>.<br>
        {t}This happens due to organizational policy or user choice:{/t}
    </p>
</div>

{render acl=$mfaRequiredByRuleACL}
<div class="row">
    <div class="col">
        <label>
            <input name="mfaRequiredByRule" type="checkbox" {if $mfaRequiredByRule == "checked"}checked{/if}>
            <span>{t}Additional factors required by organizational policy.{/t}</span>
        </label>
    </div>
</div>
{/render}
{render acl=$mfaRequiredByUserACLorCurrentUser}
<div class="row">
    <div class="col">
        <label>
            <input name="mfaRequiredByUser" type="checkbox" {if $mfaRequiredByUser == "checked"}checked{/if}/>
            <span>
                {t}Always require additional factors.{/t}
            </span>
        </label>
    </div>
</div>
{/render}

{if $parent == "roletabs"}
{render acl=$allowedTokenTypesACL}
<h2>{t}Allowed factors{/t}</h2>
<div class="row">
    <div class="input field col s12">
        <select name="allowedTokenTypes[]" multiple>
            <option value="" disabled{if empty(tokenTypes)} selected{/if}>{t}Choose allowed factors{/t}</option>
            {foreach $allTokenTypes as $tokenType}
            <option value="{$tokenType}"{if in_array($tokenType, $tokenTypes)} selected{/if}>{$mfa_{$tokenType}_title}</option>
            {/foreach}
        </select>
        <label></label>
    </div>
</div>
{/render}
{/if}

{* If no token is registered, warn the user! *}
{if $parent == "usertabs" && $showWarningNoTokenRegistered}
<div class="card-panel red lighten-4 red-text text-darken-4">
    <b>{t}Attention: {/t}</b>{t}You cannot log in again with this account because there is no multifactor method associated with it. Please add one of the available methods now.{/t}
</div>
{/if}

<div class="row mt-1">
    <div class="col">
        <button class="btn-small primary" name="edit_apply" type="submit">{t}Save settings{/t}</button>
    </div>
</div>


{if $parent == "usertabs"}
{render acl=$manageTokensACLorCurrentUser}
<hr class="divider">
<h2>{t}Add new multifactor token{/t}</h2>
{if count($tokenTypes) > 0}
    <div class="row">
        <p>
        {t}Here you can add a new login method for your account. You can choose between different methods below.{/t}
        </p>
    </div>

    <div class="row">
        {foreach $tokenTypes as $tokenType}
            {* TODO: Calculate based on token type count? *}
            <div class="col s12 m12 l6 xl3">
                <div class="card large">
                    <div class="card-content">
                        <i class="material-icons left">{$mfa_{$tokenType}_icon}</i>
                        <span class="card-title">{$mfa_{$tokenType}_title}</span>
                        <p>
                            {$mfa_{$tokenType}_description}
                        </p>
                    </div>

                    <div class="card-action">
                        {if empty({$mfa_{$tokenType}_limitReachedMessage})}
                            <button
                                class="btn-small primary"
                                name="add_token"
                                value="{$tokenType}"
                                type="submit"
                            >
                            {$mfa_{$tokenType}_button_text}
                            </button>
                        {else}
                            <button
                                class="btn-small primary"
                                title="{$mfa_{$tokenType}_limitReachedMessage}"
                                disabled
                            >
                            {$mfa_{$tokenType}_button_text}
                            </button>
                        {/if}
                    </div>
                </div>
            </div>
        {/foreach}
    </div>
{else}
    <div class="row">
        <p>
        {t}You are not allowed to configure any additional multifactor tokens.{/t}
        </p>
    </div>
{/if}

<style>
.txtonlybtn {
        background:none;
        border:none;
        margin:0;
        padding:0;
        cursor: pointer;
        font-size: 1em;
}
</style>

<hr class="divider">
<h2>{t}Associated multifactor methods{/t}</h2>
<div class="row">
    {if count($tokens) > 0}
        <div class="col-md-12 col-xl-9">
        <table class="table">
            <thead>
                <tr>
                    <th style="width: 2%" ><input type="checkbox"></th>
                    <th style="width: 5%" >{t}ID{/t}</th>
                    <th style="width: 20%">{t}Type{/t}</th>
                    <th>{t}Description{/t}</th>
                    <th style="width: 15%">{t}Last use{/t}</th>
                    <th style="width: 5%" >{t}Status{/t}</th>
                    <th style="width: 5%" >{t}Error counter{/t}</th>
                    <th style="width: 10%">{t}Actions{/t}</th>
                </tr>
            </thead>
            <tbody>
                {foreach from=$tokens key=$key item=$token}
                    <form method="post">
                    {* Indicate mfaAccount that we want to execute an action on a token *}
                    <input type="hidden" id="tokenSerial" name="tokenSerial" value="{$token.serial}">
                    <input type="hidden" name="php_c_check" value="1">
                    <tr>
                        <td><input type="checkbox"></td>
                        <td><button class="txtonlybtn" type="submit" name="mfaTokenAction" value="mfaTokenView">{$token.serial}</button></td>
                        <td>
                            {* TODO: Refactor getSetupCard{Icon,Title}, also mfa{tokenType}_{icon,title}.
                             * There are only available if in allowedTokenType or overriden by ACL.
                             * Make them a const in the MFA{Icon, Title}Token class. *}
                            {* TODO: Center text vertically *}
                             <button class="txtonlybtn" type="submit" name="mfaTokenAction" value="mfaTokenView">
                                <span class="material-icons">{$mfa_{$token.tokentype}_icon}</span>
                                {$mfa_{$token.tokentype}_title}
                            </button>
                        </td>
                        <td><button class="txtonlybtn" type="submit" name="mfaTokenAction" value="mfaTokenView">{if strpos($tokenDescriptionACL, "r") !== false}{$token.description}{else}{t}hidden{/t}{/if}</button></td>
                        <td>{if strpos($tokenLastUsedACL, "r") !== false}{$token.info.last_auth}{else}{t}hidden{/t}{/if}</td>
                        <td>{if strpos($tokenStatusACL, "r") !== false}{$token.status}{else}{t}hidden{/t}{/if}</td>
                        <td>{if strpos($tokenFailCountACL, "r") !== false}{$token.failcount}{else}{t}hidden{/t}{/if}/{$token.maxfail}</td>
                        <td>
                            {render acl=$tokenDescriptionACL}
                            <button class="txtonlybtn" type="submit" name="mfaTokenAction" value="mfaTokenEdit" title="{t}Edit{/t}">
                                <span class="material-icons">edit</span>
                            </button>
                            {/render}
                    {if !$token.revoked}
                            {render acl=$tokenFailCountACL}
                            <button class="txtonlybtn" type="submit" name="mfaTokenAction" value="mfaTokenResetCounter" title="{t}Reset error counter{/t}">
                                <span class="material-icons">restart_alt</span>
                            </button>
                            {/render}
                        {if $token.active}
                            {render acl=$tokenStatusACL}
                            <button class="txtonlybtn" type="submit" name="mfaTokenAction" value="mfaTokenDisable" title="{t}Deactivate{/t}">
                                <span class="material-icons">lock</span>
                            </button>
                            {/render}
                        {else}
                            {render acl=$tokenStatusACL}
                            <button class="txtonlybtn" type="submit" name="mfaTokenAction" value="mfaTokenEnable" title="{t}Activate{/t}">
                                <span class="material-icons">lock_open</span>
                            </button>
                            {/render}
                        {/if}
                            {render acl=$tokenRevocationACL}
                            <button class="txtonlybtn" type="submit" name="mfaTokenAction" value="mfaTokenRevoke" title="{t}Revoke{/t}">
                                <span class="material-icons">cancel</span>
                            </button>
                            {/render}
                    {/if}
                            {render acl=$tokenRemovalACL}
                            <button class="txtonlybtn" type="submit" name="mfaTokenAction" value="mfaTokenRemove" title="{t}Remove{/t}">
                                <span class="material-icons">delete_forever</span>
                            </button>
                            {/render}
                        </td>
                    </tr>
                    </form>
                {/foreach}
            </tbody>
        </table>
        </div>
    {else}
        <span>{t}Currently there are no multifactor methods associated.{/t}</span>
    {/if}
</div>
{/render}
{/if}
