{* Вкладки *}
{capture name=tabs}
    {if in_array('orders', $manager->permissions)}
        <li class="orders-tab relative {if $order->status==0}active{/if}"><a href="{url module=OrdersAdmin status=0 id=null}">Новые</a></li>
        <li class="orders-tab relative {if $order->status==5}active{/if}"><a href="{url module=OrdersAdmin status=5 id=null}">Примерка</a></li>
        <li class="orders-tab relative {if $order->status==6}active{/if}"><a href="{url module=OrdersAdmin status=6 id=null}">Визиты</a></li>
        <li class="orders-tab relative {if $order->status==4}active{/if}"><a href="{url module=OrdersAdmin status=4 id=null}">Забронированные</a></li>
        <li class="orders-tab relative {if $order->status==1}active{/if}"><a href="{url module=OrdersAdmin status=1 id=null}">В работе</a></li>
        <li class="orders-tab relative {if $order->status==2}active{/if}"><a href="{url module=OrdersAdmin status=2 id=null}">Завершенные</a></li>
        <li class="orders-tab relative {if $order->status==3}active{/if} red-status"><a href="{url module=OrdersAdmin status=3 id=null}">Удалены</a></li>
        {if $keyword}
            <li class="orders-tab relative active"><a href="{url module=OrdersAdmin keyword=$keyword id=null label=null}">Поиск</a></li>
        {/if}
        <li><a class="orders-tab relative" href="{url module=StatsRentCalendarOrdersAdmin}">Календарь аренд</a></li>
        <li class="orders-tab relative "><a href="{url module=PromPurchasesAdmin status=null id=null}">Выпускной {$promYear}</a></li>
{*        <li class="orders-tab relative "><a href="{url module=VisitsAdmin status=null id=null}">Визиты</a></li>*}
    {/if}
{/capture}

{if $order->id}
    {$meta_title = "Заказ №`$order->id`" scope=parent}
{else}
    {$meta_title = 'Новый заказ' scope=parent}
{/if}
<!-- Основная форма -->
{literal}
<style>
    .popup-fade:before {
        content: '';
        background: #000;
        position: fixed;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        opacity: 0.7;
        z-index: 9999;
    }
    .popup {
        position: fixed;
        top: 20%;
        left: 39%;
        padding: 20px;
        width: 360px;
        margin-left: -200px;
        background: #fff;
        border: 1px solid orange;
        border-radius: 4px;
        z-index: 99999;
        opacity: 1;
    }
    .popup-close {
        position: absolute;
        top: 10px;
        right: 10px;
    }
    .textlabel{

        width: 93px;
        height: 24px;
        font-family: Gilroy;
        font-size: 24px;
        font-weight: normal;
        font-stretch: normal;
        font-style: normal;
        line-height: normal;
        letter-spacing: normal;
        text-align: center;
        color: #2a2a2a;
        margin-left:28%

    }
    .textlabel2{

        width: 93px;
        height: 24px;
        font-family: Gilroy;
        font-size: 24px;
        font-weight: normal;
        font-stretch: normal;
        font-style: normal;
        line-height: normal;
        letter-spacing: normal;
        text-align: center;
        color: #2a2a2a;
        margin-left:15%

    }
    .label {
        width: 427px;
        height: 25px;
        font-family: Gilroy;
        font-size: 13px;
        font-weight: bold;
        font-stretch: normal;
        font-style: normal;
        line-height: 1.62;
        letter-spacing: normal;
        text-align: center;
        color: #2a2a2a;
        margin-left:15px;
    }
    .list{
        width: 357px;
        /*height: 143px;*/
        font-family: Gilroy;
        font-size: 13px;
        font-weight: normal;
        font-stretch: normal;
        font-style: normal;
        line-height: 1.85;
        letter-spacing: normal;
        color: #2a2a2a;
        margin-top:20px;
    }
    .Rectangle {
        width: 361px;
        height: 134px;
        border: solid 1px #e0e0e0;
        background-color: #ffffff;
        margin-bottom: 20px;
    }
    .downlabel{
        width: 360px;
        height: 46px;
        font-family: Gilroy;
        font-size: 13px;
        font-weight: bold;
        font-stretch: normal;
        font-style: normal;
        line-height: 1.54;
        letter-spacing: normal;
        text-align: center;
        color: #2a2a2a;
    }
    .container {
        margin-left:0px;
    }
</style>
{/literal}
<form method=post id=order enctype="multipart/form-data">
    <div class="popup-fade" style="display:none">
        <div class="popup container">
            <a class="popup-close" href="#">X</a>
            <span class="textlabel">Возврат</span><br>
            <span class="label">По какой причине вещь не подошла?</span><br>
            <ul class="list">
                <li><input type="radio" id="radioButton" name="radio">Не подошел размер (маленький)</li>
                <li><input type="radio" id="radioButton" name="radio">Не подошел размер (большой)</li>
                <li><input type="radio" id="radioButton" name="radio">Не подошел фасон</li>
                <li><input type="radio" id="radioButton" name="radio">Пришел не тот товар</li>
                <li><input type="radio" id="radioButton" name="radio">Свой вариант</li>
            </ul><br>
            <textarea class="Rectangle" placeholder="Напиши свой вариант..."></textarea>
            <span class="downlabel">Для того чтобы выбрать вещь на которую хочешь обменять, переходи в каталог</span>
            <div class="button-wrapper clearfix form-group" id="button1">
                <button type="text" style="width: 170px;  height: 46px;  border: solid 1px #76dfd5; background-color:#FFF" class="popup-close_"><span class="reset_button">ОТМЕНИТЬ</span></button>
                <button type="text" style="width: 170px; height: 46px; background-color: #76dfd5; margin-left:8px; border:none"><span class="change_button">ОК</span></button></div>
        </div>
    </div>
    <input type=hidden name="session_id" value="{$smarty.session.id}">

    <div id="name">
        <input name=id type="hidden" value="{$order->id|escape}" class="order-id">
        {*<input type="hidden" value="{$order->city_id|escape}" class="order_city_id">*}
        <input type="hidden" value="{$manager->city}" class="order_city_id">

        <h1>{if $order->id}Заказ №{$order->id|escape}{else}Новый заказ{/if}</h1>
        <div class="order-header clearfix">
            <input class="order-status" type="hidden" value="{$order->status}">
            <div class="select-wrapper gray">
                <div class="select-inner">
                    <select class="status" name="status" {if $order && $order->status == 3}disabled{/if}>
                        <option value='0' {if $order->status == 0}selected{/if}>Новый</option>
                        <option value='5' {if $order->status == 5}selected{/if}>Примерка</option>
                        <option value='4' {if $order->status == 4}selected{/if}>Забронирован</option>
                        <option value='1' {if $order->status == 1}selected{/if}>В работе</option>
                        <option value='2' {if $order->status == 2}selected{/if}>Завершенный</option>
                        <option value='3' {if $order->status == 3}selected{/if}>Удален</option>
                    </select>
                </div>
            </div>
            <div class="checkbox-wrapper">
                <input type="checkbox" name="paid" id="paid" value="1" {if $order->paid}checked{/if} {if $order && $order->status == 3}disabled{/if}>
            </div>
            <label for="paid" class="{if $order->paid}green{/if} paid-label text-field-height">Заказ оплачен</label>
            {if !$order || $order->status != 3}<input type="button" class="button_green button_save_left button_submit" name="" value="Сохранить">{/if}
            {*<div id=next_order>*}
            {*{if $prev_order}*}
            {*<a class=prev_order href="{url id=$prev_order->id}">←</a>*}
            {*{/if}*}
            {*{if $next_order}*}
            {*<a class=next_order href="{url id=$next_order->id}"><img src="design/images/next-order.png"></a>*}
            {*{/if}*}
            {*</div>*}
        </div>
        <div class="stickers-anchors right margin-top-10">
            <a class="button stickers-btn" href="?module=TrackerTaskAdmin&order_id={$order->id}">Стикеры</a>
            <a class="button new_sticker" href="?module=TrackerStickerAdmin&id=0&task_id=common&order_id={$order->id}&new=1">&nbsp;</a>
        </div>
    </div>
    {if $smtp_message_error}
        <!-- Системное сообщение -->
        <div class="message message_error">
            <span>
                {$smtp_message_error}
            </span>
        </div>
    {elseif $message_error}
        <!-- Системное сообщение -->
        <div class="message message_error">
            <span>
                {if $message_error == 'error_closing'}
                    Нехватка товара на складе
                {elseif $message_error == 'order_has_variant_copies'}
                    В заказе может быть только один екземпляр товара.
                {elseif $message_error == 'update_deleted_order'}
                    Удаленные заказы не могут быть изменены
                {elseif $message_error == 'no_purchases'}
                    Заказ должен местить хотя бы один товар
                {elseif $message_error == 'new_order_with_prepayment'}
                    Статус товара с оплатой не может быть "Новый"
                {elseif $message_error == 'has_blocked_rents'}
                    Товар уже зарезервирован на ближайшие будущие даты. Обратите внимание, возможно недостаточно времени на доставку/химчистку
                {elseif $message_error == 'updated'}
                    Ошибка при сохранении товара
                {elseif $message_error == 'added'}
                    Ошибка при добалении товара
                {elseif $message_error == 'has_blocked_sales'}
                    Товар уже зарезервирован на ближайшие будущие даты.
                    <br>
                    Обратите внимание, возможно недостаточно времени на доставку/химчистку
                {elseif $message_error == 'rent_start_date_error'}
                    Для одной из аренд не была указана дата начала
                {elseif $message_error == 'error_sending_service_quality_poll'}
                    Ошибка отправления опроса по завершению заказа
                {else}
                    {$message_error|escape}
                {/if}
            </span>
            {if $smarty.get.return}
                <a class="button" href="{$smarty.get.return}">Вернуться</a>
            {/if}
        </div>
        <!-- Системное сообщение (The End)-->
    {elseif $message_success}
        <!-- Системное сообщение -->
        <div class="message message_success">
            <span>{if $message_success=='updated'}Заказ обновлен{elseif $message_success=='added'}Заказ добавлен{elseif $message_success == 'service_quality_poll_sent'}Опрос по завершению заказа отправлен{else}{$message_success}{/if}</span>
            {if $smarty.get.return}
                <a class="button" href="{$smarty.get.return}">Вернуться</a>
            {/if}
        </div>
        {if $message_success_send == 'service_quality_poll_sent'}
            <div class="message message_success">
                <span>Опрос по завершению заказа отправлен</span>
                {if $smarty.get.return}
                    <a class="button" href="{$smarty.get.return}">Вернуться</a>
                {/if}
            </div>
        {/if}
        <!-- Системное сообщение (The End)-->
    {/if}
    {if $message_info}
        <div class="message message_info">
            <span>
                {if $message_info == 'require_transportation'}
                    Требуется перевозка в другой город
                {/if}
            </span>
        </div>
    {/if}
    {*Сообщение об возвращенни бонусов клиенту*}
    {if $bonuses_for_return}
        <div class="message message_success">
            <span>Клиенту возвращено {$bonuses_for_return} бонусов, которыми он оплачивал этот заказ</span>
            {if $smarty.get.return}
                <a class="button" href="{$smarty.get.return}">Вернуться</a>
            {/if}
        </div>
    {/if}

    <div id="purchases">
        <div id="list" class="purchases">
            {$rentsCount = 0}
            {foreach from=$purchases item=purchase}
                {if $purchase->rent == 1}{$rentsCount = $rentsCount + 1}{/if}
                <div class="row">
                    <div class="image cell">
                        <input type=hidden name=purchases[id][{$purchase->id}] value='{$purchase->id}' class="purchase-id">
                        {$image = $purchase->product->images|first}
                        {if $image}
                            <img class=product_icon src='{$image->filename|resize:35:35}'>
                        {/if}
                    </div>
                    <div class="purchase_name cell">
                        <div class='purchase_date'>
                        <span class=edit_purchase style="display:none;">
                            <input type="text" class="product_date text-field" value="{$purchase->start_date|date_format:'%d.%m.%Y'}" {if $purchase->rent=='0'}style="display:none;"{/if}>
                            <input type="hidden" name="purchases[start_date][{$purchase->id}]" id="alt_date_{$purchase->variant->id}" value="{$purchase->start_date|date_format:'%Y-%m-%d'}">
                            <input type="hidden" class="cash_bonus" value="{$purchase->variant->cash_bonus}">
                        </span>
                            <span class=view_purchase>
                            {if $purchase->rent == '1'}
                                {$purchase->start_date|date_format:'%d.%m.%Y'}
                            {/if}
                        </span>
                        </div>
                        {$sizesCounter = 0}
                        {if $purchase->product->sizes && $purchase->product->sizes|@count > 0}
                            {foreach $sizes as $s => $size}
                                {if in_array($s, $purchase->product->sizes)}
                                    {$sizesCounter = $sizesCounter + 1}
                                {/if}
                            {/foreach}
                        {/if}
                        {if $sizesCounter > 0}
                            <div class="purchase_size">
                                <span class='edit_purchase' style='display:none;'>
                                    <div class="select-wrapper very-narrow gray">
                                        <div class="select-inner">
                                            <select name="purchases[size_id][{$purchase->id}]" id="s1">
                                                {foreach $sizes as $s => $size}
                                                    {if in_array($s, $purchase->product->sizes)}
                                                        <option value="{$s}"{if $s eq $purchase->size_id} selected="selected"{else}style="display: none;"{/if}>{$size}</option>
                                                    {/if}
                                                {/foreach}
                                            </select>
                                        </div>
                                    </div>
                                </span>
                                <span class='view_purchase'>
                                    {$purchase->size}
                                </span>
                            </div>
                        {else}
                            <input type="hidden" name="purchases[size_id][{$purchase->id}]" value="">
                        {/if}

                        <div class='purchase_variant'>
                            <span class='edit_purchase' style='display: none;'>
                                <div class=" select-wrapper very-narrow gray">
                                    <div class="select-inner">
                                        <select name="purchases[variant_id][{$purchase->id}]" {if $purchase->product->variants|count==1 && $purchase->variant_name == '' && $purchase->variant->sku == ''}style='display:none;'{/if}>
                                            {if $order->status == 2}
                                                {if $purchase->rent!='1'}
                                                    {$additionalAmount = $purchase->amount}
                                                {/if}
                                            {else}
                                                {$additionalAmount = 0}
                                            {/if}
                                            {if !$purchase->variant}
                                                <option price='{$purchase->price|string_format:"%.0f"}' amount='{$purchase->amount}' value=''>{$purchase->variant_name|escape} {if $purchase->sku}(арт. {$purchase->sku}){/if}</option>{/if}
                                            {foreach $purchase->product->variants as $v}
                                                {if $v->stock>0 || $v->id == $purchase->variant->id}
                                                    <option city_id='{$v->city_id}' sellers_price='{$v->sellers_price|string_format:"%.0f"}' price='{$v->price|string_format:"%.0f"}' compare_price='{$v->compare_price|string_format:"%.0f"}' amount='{$v->stock + $additionalAmount}' size='{$v->size}' value='{$v->id}' {if $v->id == $purchase->variant_id}selected{/if} cash_bonus='{$v->cash_bonus}'>
                                                        {$v->name}
                                                        {if $v->sku}(арт. {$v->sku}){/if}
                                                    </option>
                                                {/if}
                                            {/foreach}
                                        </select>
                                    </div>
                                </div>
                            </span>
                            <span class=view_purchase>
                                {$purchase->variant_name} {if $purchase->sku}(арт. {$purchase->sku}){/if}
                                {if $purchase->city_id==1}
                                    <span class="order_city">Киев</span>
                                {elseif $purchase->city_id==2}
                                    <span class="order_city">Одесса</span>
                                {elseif $purchase->city_id==4}
                                    <span class="order_city">Харьков</span>
                                {/if}
                            </span>
                        </div>
                        <div class="pur_name">
                            {if $purchase->product}
                                <a class="related_product_name" href="index.php?module=ProductAdmin&id={$purchase->product->id}&return={$smarty.server.REQUEST_URI|urlencode}">{$purchase->product_name}</a>
                            {else}
                                {$purchase->product_name}
                            {/if}
                        </div>
                    </div>
                    <div class="price cell">
                        <span class="view_purchase">{$purchase->price|string_format:"%.0f"} {if $purchase->rent=='0'}{$currency->sign}<br>{$purchase->variant->sellers_price|string_format:"%.0f"}</span>{/if}
                        <span class="edit_purchase" style='display:none;'>
                            <input class="priceVal text-field" type="text" name="purchases[price][{$purchase->id}]" value='{$purchase->price|string_format:"%.0f"}' size="5" {if $purchase->ownerId}data-is_accessory="{if $purchase->isAccessory == false}false{else}true{/if}" data-owner_id="{$purchase->ownerId}"{/if} data-owner_bonus_percent="{$purchase->variant->bonus_value}">
                            <br>
                            {if $purchase->rent=='0'}
                                <span class="sellersPriceText">{$purchase->variant->sellers_price|string_format:"%.0f"}</span>
                            {/if}
                        </span>
                        {$currency->sign}
                    </div>
                    <div class="amount cell">
                        <span class="view_purchase">
                            {if $purchase->rent=='1'}
                                {$purchase->amount}
                                {if $purchase->amount == 1}
                                    день
                                {else}
                                    {if $purchase->amount > 1 and $purchase->amount < 5}
                                        дня
                                    {else}
                                        дней
                                    {/if}
                                {/if}
                            {/if}
                            {if $purchase->rent=='0'}
                                {$purchase->amount} шт.
                            {/if}
                        </span>
                        <span class="edit_purchase" style='display:none;'>
                            {if $purchase->variant}
                                {math equation="max(x,y)" x=$purchase->variant->stock y=$purchase->amount assign="loop"}
                            {else}
                                {math equation="x" x=$purchase->amount assign="loop"}
                            {/if}
                            <div class=" select-wrapper very-narrow gray">
                                <div class="select-inner">
                                    <select name=purchases[amount][{$purchase->id}]>
                                        {if $purchase->rent=='1'}
                                            {$to = 32}
                                            {section name=amounts start=1 loop=$to step=1}
                                                <option value="{$smarty.section.amounts.index}" {if $purchase->amount==$smarty.section.amounts.index}selected{/if}>{$smarty.section.amounts.index} {if $smarty.section.amounts.index == 1}день{else}{if $smarty.section.amounts.index > 1 and $smarty.section.amounts.index < 5}дня{else}дней{/if}{/if}</option>
                                            {/section}
                                        {else}
                                            {if $order->status == 2}
                                            {$end = $purchase->amount+1}
                                        {else}
                                            {$end = 1}
                                        {/if}
                                            {section name=amounts start=1 loop=$purchase->variant->stock+($end) step=1}
                                            <option value="{$smarty.section.amounts.index}" {if $purchase->amount==$smarty.section.amounts.index}selected{/if}>{$smarty.section.amounts.index} шт.</option>
                                        {/section}
                                        {/if}
                                    </select>
                                </div>
                            </div>
                        </span>
                    </div>
                    <div class="purchase-type cell">
                        <span class="view_purchase">
                            {if $purchase->rent == 0}Выкуп{else}Аренда{/if}
                        </span>
                        <span class="edit_purchase" style='display:none;'>
                            <div class="select-wrapper gray very-narrow">
                                <div class="select-inner">
                                    <select name="purchases[rent][{$purchase->id}]" class="is-rent">
                                        <option {if $purchase->rent == 1}selected{/if} value="1">Аренда</option>
                                        <option {if $purchase->rent == 0}selected{/if} value="0">Выкуп</option>
                                         {if $subscriptions|@count > 0}
                                             <option  value="3">Вернуть</option>
                                             <option  value="4">На будущий месяц</option>
                                         {/if}
                                    </select>
                                </div>
                            </div>
                        </span>
                    </div>
                    <div class="icons cell">
                        {if !$order || $order->status != 3}<a href='#' class="delete" title="Удалить"></a>{/if}
                        {if !$order->closed}
                            {if !$purchase->product}
                                <img src='design/images/error.png' alt='Товар был удалён' title='Товар был удалён'>
                            {elseif !$purchase->variant}
                                <img src='design/images/error.png' alt='Вариант товара был удалён' title='Вариант товара был удалён'>
                            {elseif $purchase->variant->stock < $purchase->amount}
                                {*<img src='design/images/error.png' alt='На складе остал{$purchase->variant->stock|plural:'ся':'ось'} {$purchase->variant->stock} товар{$purchase->variant->stock|plural:'':'ов':'а'}' title='На складе остал{$purchase->variant->stock|plural:'ся':'ось'} {$purchase->variant->stock} товар{$purchase->variant->stock|plural:'':'ов':'а'}'  >*}
                            {/if}
                        {/if}
                        {*<a href='javascript:void(0)' class="rent {if $purchase->rent=='1'}rent_active{/if}" title="Арендовать"></a>*}
                        {*<input type="hidden" name="purchases[rent][{$purchase->id}]" value="{$purchase->rent}" class="is-rent">*}
                    </div>
                    <div class="clear"></div>
                </div>
            {/foreach}


            <div id="new_purchase" class="row" style="display:none;">
                <div class="image cell">
                    <input type="hidden" name="purchases[id][]" value='' class="purchase-id">
                    <img class="product_icon" src=''>
                </div>

                <div class="purchase_name cell">
                    <div class='purchase_date'>
                        <span class=edit_purchase>
                            <input type="text" style="display: none;" class="product_date text-field" value="">
                            <input type="hidden" name="purchases[start_date][]" id="alt_date_" value="">
                            <input type="hidden" class="cash_bonus" value="">
                        </span>
                        <span class="view_purchase"></span>
                    </div>
                    <div class="purchase_size">
                        <span class="edit_purchase">
                            <div class=" select-wrapper very-narrow gray">
                                <div class="select-inner">
                                    <select name="purchases[size_id][]" id="s1"></select>
                                </div>
                            </div>
                        </span>
                    </div>
                    <div class='purchase_variant'>
                        <div class=" select-wrapper very-narrow gray">
                            <div class="select-inner">
                                <select name="purchases[variant_id][]"></select>
                            </div>
                        </div>
                    </div>
                    <div class="pur_name">
                        <a class="purchase_name" href=""></a>
                    </div>
                </div>
                <div class="price cell">
                    <input type="text" name="purchases[price][]" value='' size="5" class="text-field">
                    <span style="display:none;" class="sellersPriceText"></span>
                    {$currency->sign}
                </div>
                <div class="amount cell">
                    <div class=" select-wrapper very-narrow gray">
                        <div class="select-inner">
                            <select name="purchases[amount][]"></select>
                        </div>
                    </div>
                </div>
                <div class="purchase-type cell">
                    <div class="select-wrapper gray very-narrow">
                        <div class="select-inner">
                            <select name="purchases[rent][]" class="is-rent">
                                <option value="1" selected>Аренда</option>
                                <option value="0">Выкуп</option>
                                {if $subscriptions|@count > 0}
                                    <option  value="3">Вернуть</option>
                                    <option  value="4">На будущий месяц</option>
                                {/if}
                            </select>
                        </div>
                    </div>
                </div>
                <div class="icons cell">
                    {if !$order || $order->status != 3}<a href='#' class="delete" title="Удалить"></a>{/if}
                    {*<a href='javascript:void(0)' class="rent" title="Арендовать"></a>*}
                    {*<input type="hidden" name="purchases[rent][]" value="0" class="is-rent">*}
                </div>
                <div class="clear"></div>
            </div>
        </div>

        <div id="add_purchase" {if $purchases}style='display:none;'{/if}>
            <input type="text" name="related" id='add_purchase' class="input_autocomplete text-field" placeholder='Выберите товар чтобы добавить его'>
        </div>

        <div id="add_purchase_by_barcode" {if $purchases}style='display:none;'{/if}>
            <input type="search" name="related_barcode" id='add_purchase_by_barcode' class="input_autocomplete_barcode text-field" placeholder='Выберите штрих код чтобы добавить товар'>
        </div>

        {if $purchases && (!$order || $order->status != 3)}
            <a href='#' class="dash_link edit_purchases">редактировать покупки</a>
        {/if}

        {if $purchases}
            <div id="sum_variants" class="subtotal">
                Всего<b> {$subtotal|string_format:"%.2f"} {$currency->sign}</b>
            </div>
        {/if}
    </div>

    <div id="order_details">
        <h2 class="no-float">
            Детали заказа
            {if !$order || $order->status != 3}<a href='#' class="edit_order_details"><img src='design/images/pencil.png' alt='Редактировать' title='Редактировать'></a>{/if}
            <a href="{url view=print id=$order->id}" class='print-order' target="_blank"><img src="./design/images/printer_small.png" name="export" title="Печать заказа"></a>
            <a href="{url view=print_receipt id=$order->id}" class='print-order' target="_blank"><img src="./design/images/receipt.png" title="Печать квитанции" style="max-width: 16px"></a>
        </h2>
        <div id="user">
            <ul class="order_details">
                <li>
                    <label class=property>Дата</label>
                    <div class="edit_order_detail view_order_detail">
                        <input type="hidden" id="created-date" value="{$order->date|date_format:'%Y-%m-%d'}" />
                        {$order->date|date_format:'%d.%m.%Y %H:%M:%S'} {$order->time}
                    </div>
                </li>
                <li>
                    <label class=property>Имя</label>
                    <div class="edit_order_detail" style='display:none;'>
                        <input name="name" class="ohmypro_inp" type="text" value="{$order->name|escape}">
                    </div>
                    <div class="view_order_detail">
                        {$order->name|escape}
                    </div>
                </li>
                <li>
                    <label class=property>Email</label>
                    <div class="edit_order_detail" style='display:none;'>
                        <input name="email" class="ohmypro_inp" type="text" value="{$order->email|escape}">
                    </div>
                    <div class="view_order_detail">
                        <a href="mailto:{$order->email|escape}?subject=Заказ%20№{$order->id}">{$order->email|escape}</a>
                    </div>
                </li>
                <li>
                    <label class=property>Телефон</label>
                    <div class="edit_order_detail" style='display:none;'>
                        <input name="phone" class="ohmypro_inp" type="text" value="{$order->phone|escape}">
                    </div>
                    <div class="view_order_detail">
                        {$order->phone|escape}
                    </div>
                </li>
                <li>
                    <label class=property>Адрес <a href='http://maps.yandex.ru/' id=address_link target=_blank><img align=absmiddle src='design/images/map.png' alt='Карта в новом окне' title='Карта в новом окне'></a></label>
                    <div class="edit_order_detail" style='display:none;'>
                        <textarea name="address">{$order->address|escape}</textarea>
                    </div>
                    <div class="view_order_detail">
                        {$order->address|escape}
                    </div>
                </li>
                <li>
                    <label class=property>Удобное время доставки</label>
                    <div class="edit_order_detail" style='display:none;'>
                        <input name="delivery_time" class="ohmypro_inp" type="text" value="{$order->delivery_time|escape}">
                    </div>
                    <div class="view_order_detail">
                        {$order->delivery_time|escape}
                    </div>
                </li>
                <li>
                    <label class=property>Комментарий покупателя</label>
                    <div class="edit_order_detail" style='display:none;'>
                        <textarea name="comment">{$order->comment|escape}</textarea>
                    </div>
                    <div class="view_order_detail">
                        {$order->comment|escape|nl2br}
                    </div>
                </li>
            </ul>
        </div>


        {if $labels}
            <div class='layer'>
                <h2 class="no-float">Метка</h2>
                <!-- Метки -->
                <ul>
                    {foreach $labels as $l}
                        <li>
                            <label for="label_{$l->id}">
                                <input id="label_{$l->id}" type="checkbox" name="order_labels[]" value="{$l->id}" {if in_array($l->id, $order_labels)}checked{/if}>
                                <span style="background-color:#{$l->color};" class="order_label"></span>
                                {$l->name}
                            </label>
                        </li>
                    {/foreach}
                </ul>
            </div>
        {/if}

        <div class='order-user'>
            <h2 class="no-float">
                Пользователь
                {if !$order || $order->status != 3}
                    <a href='#' class="edit_user"><img src='design/images/pencil.png' alt='Редактировать' title='Редактировать'></a>
                    {if $user}<a href="#" class='delete_user'><img src='design/images/delete.png' alt='Удалить' title='Удалить'></a>{/if}
                {/if}
            </h2>
            <div class='view_user clearfix'>
                {if !$user}
                    Не зарегистрирован
                {else}
                    <a href='index.php?module=UserAdmin&id={$user->id}' target=_blank>{$user->name|escape} {$user->last_name}</a>
                    ({$user->email|escape})
                    {if $user->group_name}{$user->group_name|escape}{/if}
                    {if $user->cart_number}<img class="employer-card-img" src="design/images/card_employer.png" alt="карта покупателя" title="карта покупателя">{/if}
                    {if $userStickersCount > 0 || $userCallsCount > 0}
                        <div class="has_an_exclamation small">
                            <a href="#" class="user-exclamation"><img src="design/images/exclamation_mark.png"></a>
                            <div class="exclamation-tooltip">
                                <div class="left-border"></div>
                                <div class="content">
                                    <p>cтикеров: {$userStickersCount}</p>
                                    <p>звонков: {$userCallsCount}</p>
                                </div>
                            </div>
                        </div>
                    {/if}
                {/if}
            </div>
            <div class='edit_user' style='display:none;'>
                <input type="hidden" name="user_id" value='{$user->id}'>
                <input type="hidden" name="subscription_id" value=''>
                <input type="hidden" name="subscription_count_products" value=''>
                <input type="hidden" name="subscription_products" value=''>
                {if !$order || $order->status != 3}<input type="text" id='user' class="input_autocomplete text-field gray" placeholder="Выберите пользователя">{/if}
            </div>
            <div id="cart_number_search_block" style='display:none;'>
                {if !$order || $order->status != 3}<input id="cart_number_search_input1" class="search  text-field" type="text" name="cart_number_keyword" value="{$cart_number_keyword|escape}" placeholder=" поиск по карте покупателя">{/if}
            </div>
            <div id="phone_search_block" style='display:none;'>
                {if !$order || $order->status != 3}<input id="inputSearchUserByPhone" class="search text-field" type="text" name="phone_keyword" value="{$cart_number_keyword|escape}" placeholder=" поиск по номеру телефона">{/if}
            </div>

            {$showUserAddInfo = false}
            {if $user->sub_group_name != null && $user->sub_group_name  != ''}
                {$showUserAddInfo = true}
            {/if}
            <div class="user-add-info" style="{if !$showUserAddInfo}display: none;"{/if}>
                <span class="user-sub-group">{$user->sub_group_name}</span>
            </div>
        </div>

        <div class='layer'>
            <h2 class="no-float">Менеджер</h2>
            <div class='view_manager clearfix'>
                {*{if $from_site}*}
                {*Менеджер : сайт*}
                {*<input  type="hidden" id="manager-present" value="1">*}
                {*<input  type="hidden" name="from_site" value="1">*}
                {*{elseif $history_user}*}
                {*Менеджер : {$history_user}*}
                {*<input  type="hidden"  id="manager-present" value="1">*}
                {*<input  type="hidden" name="manager" value="{$history_user}">*}
                {*{else}*}
                <input type="hidden" id="manager-present" value="0">
                <div class="select-wrapper gray">
                    <div class="select-inner">
                        <select name="manager" class="order-managers" {if $order && $order->status == 3}disabled{/if}>
                            <option value="">Выберите менджера</option>
                            {if $managers|@count > 0}
                                {foreach $managers as $manager}
                                    {if ($current_manager->city == '' || $current_manager->city == $manager->city) && ($manager->group == 'seller' or $manager->group == 'manager') && $manager->active == '1'}
                                        <option value="{$manager->login}" data-city-id="{$manager->city}" {if $order->manager == $manager->login}selected{elseif !$order->manager && $manager->login == $current_manager->login}selected{/if}>{$manager->login}</option>
                                    {/if}
                                {/foreach}
                            {/if}
                        </select>
                    </div>
                </div>
                {*{/if}*}
            </div>
        </div>
        {if $subscriptions|@count > 0}
            <div class='layer subscription_view'>
                <h2 class="no-float">Подписка</h2>
                <div class='clearfix'>
                    <div class="select-wrapper gray">
                        <div class="select-inner">
                            <select name="subscription_id" class="order-subscription" {if $order && $order->status == 3}disabled{/if}>
                                <option value="">Выберите подписку</option>

                                    {foreach $subscriptions as $subscription}
                                            <option value="{$subscription->id}" {if $order->subscription_id == $subscription->id}selected{/if}>{$subscription->name}</option>
                                    {/foreach}

                            </select>
                        </div>
                    </div>
                </div>
            </div>
        {else}
            <div class='layer subscription_view'>

            </div>
        {/if}
        {if $order}
            <div class='layer'>
                <h2 class="no-float">История</h2>
                <div class='view_user'>
                    <a href='index.php?module=HistoryAdmin&id={$order->id}' target=_blank>История заказа №{$order->id|escape}</a>
                </div>
            </div>
        {/if}

        <div class='layer'>
            <h2 class="no-float">
                Примечание
                {if !$order || $order->status != 3}<a href='#' class="edit_note"><img src='design/images/pencil.png' alt='Редактировать' title='Редактировать'></a>{/if}
            </h2>
            <ul class="order_details">
                <li>
                    <div class="edit_note" style='display:none;'>
                        <label class="property">Ваше примечание (не видно пользователю)</label>
                        {if !$order || $order->status != 3}<textarea name="note">{$order->note|escape}</textarea>{/if}
                    </div>
                    <div class="view_note" {if !$order->note}style='display:none;'{/if}>
                        <label class=property>Ваше примечание (не видно пользователю)</label>
                        <div class="note_text">{$order->note|escape}</div>
                    </div>
                </li>
                <li class="no-display cash-bonus-note">
                    <div class="view_note">
                        <div class="note_text">Денежный бонус владельцу</div>
                    </div>
                </li>
                {if $order->trying_name != null && $order->trying_name != ''}
                    <li class="trying-info">
                        <div class="view_note">
                            <div class="note_text">{$order->trying_name}</div>
                        </div>
                    </li>
                {/if}
                {if $forBirthDay}
                    <li class="for-birth-day">
                        <div class="view_note">
                            <div class="note_text"><img class="birth-date-order-icon" src="design/images/birthday-cake-icon.png" alt="{$userBirthDate|date_format:"%d.%m.%Y"}" title="День рождения: {$userBirthDate|date_format:"%d.%m.%Y"}"> {$userBirthDate|date_format:"%d.%m.%Y"}</div>
                        </div>
                    </li>
                {/if}
            </ul>
        </div>
        <div class='layer'></div>
    </div>


    <div class="order-details layer">
        <input type="hidden" name="rent_reason" value="25" id="rent_reason" />
        <input type="hidden" name="other_reason" value="Подписка" />
        <input type="hidden" name="discount" class="text-field float-right" value="" />
        <input type="hidden" name="insurance" id="insurance_val" value="" />
        <input type="hidden" name="coupon_discount" value="0" />
        <input type="hidden" name="coupon_loyalty_discount" value="0" />

        <input type="hidden" name="sertificateCode" id="sertificateCode" value="{$sertificate->id}">
        <input type="hidden" name="sertificateValue" id="sertificateValue" value="{$sertificate->value}">
        <input type="hidden" name="sertificateUnits" id="sertificateUnits" value="{if $sertificate->type == 'absolute'}1{else}0{/if}">
        <input type="hidden" name="findSertificateCode" id="findSertificateCode" />

        <div class="block how_know order-block clearfix">
            <h2 class="">Откуда узнали </h2>
            <div class="clearfix float-right values">
                <div class="howKnowBlock select-wrapper gray">
                    <div class="select-inner">
                        <input type="hidden" class="text-field float-right" value='{$order->how_know}'>
                        <select name="how_know" id="how_know">
                            {foreach $how_knows as $hk}
                                <option value="{$hk->id}" {if $hk->id==$order->how_know}selected{/if} >{$hk->name}
                                </option>
                            {/foreach}
                        </select>
                    </div>
                </div>
                <input type="text" name="other_how_know" class="outputKnow text-field float-right" {if $order->how_know==25} value='{$order->other_how_know}' {/if}>
            </div>
        </div>

        <div class="block insurance order-block clearfix ">
            <h2 class=""> Дополнительная гарантия аренды</br><span class="red">(невозможно оплатить бонусами)</span></h2>
            <div class="float-right clearfix values">
                <div class="insuranceBlock">
                    <div class="checkbox-wrapper small ">
                        <input type="checkbox" name="insurance_check" {if $order->insurance_check == 1}checked{/if} id="insurance_check" {if $order && $order->status == 3}disabled{/if}>
                    </div>
                    <input type="text" name="insurance" id="insurance_val" value='{$order->insurance}' class="text-field " {if $order && $order->status == 3}disabled{/if}>
                </div>
            </div>
        </div>

        <div class="block sertificate order-block">
            <div class="clearfix">
                <h2 class="">Сертификат </h2>
                <div class="clearfix float-right values">
                    <div class="certificateUnitsBlock">

                    </div>
                </div>
            </div>
            <div class="certificate" {if !$sertificate->text}style="display: none;"{/if}>
                <div id="certificateOutput">{$sertificate->text}</div>
                <div class="certificateButtons">
                    <a class="delete_certificate">
                        {if !$order || $order->status != 3}<img title="Удалить" alt="Удалить" src="design/images/delete.png">{/if}
                    </a>
                </div>
            </div>
        </div>

        <div class="block delivery clearfix order-block">
            <div class="clearfix">
                <h2 class="">Доставка</h2>
                <div class="float-right clearfix values">
                    <div class="select-wrapper gray">
                        <div class="select-inner">
                            <select name="delivery_id" {if $order && $order->status == 3}disabled{/if}>
                                <option value="0">Не выбрана</option>
                                {foreach $deliveries as $d}
                                    <option
                                            {if $defaultValues && $d->id == 2}
                                                selected
                                                data-price="{$d->price}"
                                                data-separate-payment="{if $d->separate_payment}{$d->separate_payment}{else}0{/if}"
                                            {elseif $d->id==$delivery->id}
                                                selected
                                                data-price="{$order->delivery_price|string_format:"%.0f"}"
                                                data-separate-payment="{if $order->separate_delivery}{$order->separate_delivery}{else}0{/if}"
                                            {else}
                                                data-price="{$d->price|string_format:"%.0f"}"
                                                data-separate-payment="{if $d->separate_payment}{$d->separate_payment}{else}0{/if}"
                                            {/if}
                                            data-free-from="{if $d->free_from|string_format:"%.0f"}{$d->free_from|string_format:"%.0f"}{else}0{/if}"
                                            value="{$d->id}">{$d->name}</option>
                                {/foreach}
                            </select>
                        </div>
                    </div>
                    <input readonly type="text" name="delivery_price" value='{$order->delivery_price|string_format:"%.0f"}' class="text-field" {if $order && $order->status == 3}disabled{/if}> <span class=currency>{$currency->sign}</span>
                    <div class="clearfix">
                        <div class="separate_delivery float-right margin-top-10">
                            <label for="separate_delivery" class="float-right">оплачивается отдельно</label>
                            <div class="checkbox-wrapper small float-right">
                                <input type=checkbox id="separate_delivery" name=separate_delivery value='1' {if $order->separate_delivery}checked{/if} {if $order && $order->status == 3}disabled{/if}>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="clearfix" style="margin-top: 25px; margin-bottom: -10px;">
                <h2>Доставка из других городов</h2>
                <div class="float-right clearfix values">
                    <div class="deliveryFromAnotherCities">
                        <div class="delivery-from-cities-details">
                            <div class="delivery-from-another-city" style="display: none;">
                                <span class="currency">{$currency->sign}</span>
                            </div>
                        </div>
                        <div class="delivery-from-another-cities-total">
                            <span class="name"></span>
                            <input disabled="" type="text" value="{$order->delivery_from_another_cities|string_format:"%.0f"}" class="text-field delivery_from_another_cities value-input"><span class="currency">{$currency->sign}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div id="sum_with_delivery" class="subtotal layer no-display">
            {if $sertificate->type == 'absolute'}{$sertificate_discount = $sertificate->value}{else}{$sertificate_discount = $subtotal/100*$sertificate->value}{/if}
            С учетом доставки<b> {($subtotal-$subtotal*$order->discount/100-$order->coupon_discount-$sertificate_discount+$order->delivery_price)|round:2} {$currency->sign}</b>
        </div>

        <div class="block order-block clearfix" id="price-correction-block">
            <h2>Корректировка суммы</h2>
            <div class="float-right clearfix values">
                <input type="text" id="price-correction-description-input" name="price_correction_description" placeholder="описание корректироваки" class="text-field" value="{$order->price_correction_description|escape}">
                <input type="text" id="price-correction-input" name="price_correction" class="text-field" value="{$order->price_correction|string_format:"%.2f"}">
            </div>
        </div>

        <div class="block prepayment clearfix order-block">
            <div class="payments-history">
                {if $payments|@count > 0}
                    <h2 class="no-float">История оплат</h2>
                    {foreach $payments as $payment}
                        <div class="payment-record clearfix" style="{if $payment->rro_refund_printed}background-color:#ffe2e1;{elseif $payment->rro_check_printed}background-color:#e0ffde;{/if};">
                            <div class="payment-date">{$payment->date|date_format:'%d.%m.%Y, %H:%M'}</div>
                            <div class="payment-sum">{$payment->sum|string_format:"%.2f"} {$currency->sign}</div>
                            <div class="payment-source">{$payment->source_name|escape}</div>
                            <div class="payment-manager">{$payment->manager|escape}</div>
                            {if $payment->sum|string_format:"%.1f"} {$currency->sign > 0}
                                <a href="#" onclick="return rro.check({$payment->id}, {$payment->rro_check_printed});" class="print-report" data-toggle="tooltip" title="Напечатать чек"><img src="design/images/print.png" alt="print"></a>
                                <a href="#" onclick="return rro.refund({$payment->id}, {$payment->rro_refund_printed});" class="print-sec-report" data-toggle="tooltip" title="Напечатать чек возврата"><img src="design/images/print_red.png" alt="red print"></a>
                            {/if}
                        </div>
                    {/foreach}
                {/if}


            </div>
            <div class="clearfix">
                <h2 class="">Оплата <span class="prepayment-tip small-tip"></span></h2>
                <div class="clearfix float-right values">
                    <input type="text" name="prepayment" value='' class="text-field float-left" placeholder="0" {if $order && $order->status == 3}disabled{/if}> <label class="float-left text-field-height margin-right-10">{$currency->sign}</label>
                    <input type="hidden" id="prepayment" value="{$order->prepayment|string_format:"%.2f"}">
                    <div class="select-wrapper gray">
                        <div class="select-inner">
                            <select name="payment_method_id" {if $order && $order->status == 3}disabled{/if}>
                                {*<option value="0">Не выбрана</option>*}
                                {foreach $payment_methods as $pm}
                                    <option value="{$pm->id}" {if $pm->id==$payment_method->id}selected{/if} {if $defaultValues && $pm->id==10}selected{/if}>{$pm->name}</option>
                                {/foreach}
                            </select>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="clearfix">
            <div id="sum_with_prepayment" class="total float-right">
                {$summ = $order->total_price-$order->prepayment}
                осталось оплатить <b> {$summ|string_format:"%.2f"} {$currency->sign}</b>

            </div>
            {if $order->prepayment}
                <div class="already-paid float-right" data-value="{$order->prepayment}">
                    заплачено <b> {$order->prepayment}  {$currency->sign}</b> /&nbsp;
                </div>
            {/if}
            {if $payment_method}
                <div id="sum_total" class="subtotal float-right">
                    {*к оплате<b> {$order->total_price|convert:$payment_currency->id} {$payment_currency->sign}</b> /&nbsp;*}
                    {if $order->insurance_check == 1}
                        к оплате
                        <b> {($order->total_price+floatval($insurance))|convert:$payment_currency->id} {$payment_currency->sign} </b>
                    {else}
                        к оплате
                        <b> $order->total_price|convert:$payment_currency->id} {$payment_currency->sign}</b>
                    {/if}
                </div>
            {/if}
        </div>

        <div class="block detailsBlock">
            <h2 class="no-float">Комментарии (видно пользователю)</h2>
            <textarea name="details" class="detailsArea text-field" {if $order && $order->status == 3}readonly{/if}>{$order->details}</textarea>
        </div>

        {if $serviceQuality}
            <div class="block service-poll-results clearfix order-block">
                <h2 class="no-float">Результаты опроса по завершению заказа</h2>
                <table>
                    <tr>
                        <th>Работа сервиса</th>
                        <th>Чистота платья</th>
                        <th>Работа стилиста</th>
                    </tr>
                    <tr>
                        <td>{$serviceQuality->quality_mark}</td>
                        <td>{$serviceQuality->dress_mark}</td>
                        <td>{$serviceQuality->stylist_mark}</td>
                    </tr>
                </table>
                <br>
                <span><b>Комментарий:</b> {$serviceQuality->comment}</span>
            </div>
        {/if}

        <div class="block_save">
            <div class="checkbox-wrapper small">
                <input type="checkbox" value="1" id="notify_user" name="notify_user" {if $defaultValues}checked{/if} {if $order && $order->status == 3}disabled{/if}>
            </div>
            <label for="notify_user">Уведомить покупателя о состоянии заказа</label>
            {if !$order || $order->status != 3}<input type="button" class="button_green button_save button_submit" name="" value="Сохранить">{/if}
        </div>
        {*   subsctiption id *}
        <input type="hidden" name="subscriptionId" value='{$subscriptionId}'  id="subscriptionId"/>
    </div>

</form>
<!-- Основная форма (The End) -->

{capture name=additional_parent_content}
    <div id="boxes">
        {if $showConvertPaymentsDlg}
            <div id="payments-convert-dialog" class="window">
                <a href="#" class="close">X</a>
                <h2 class="header no-float">Удаление заказа с финансовыми записями:</h2>
                <div class="content">
                    {if $payments|@count > 0}
                        <div class="payments-history">
                            {foreach $payments as $payment}
                                <div class="payment-record clearfix">
                                    <div class="payment-date">{$payment->date|date_format:'%d.%m.%Y, %H:%M'}</div>
                                    <div class="payment-sum">{$payment->sum|string_format:"%.1f"} {$currency->sign}</div>
                                    <div class="payment-source">{$payment->source_name|escape}</div>
                                    <div class="payment-manager">{$payment->manager|escape}</div>
                                </div>
                            {/foreach}
                        </div>
                    {/if}
                    <div class="total-for-convert">Всего: {$order->prepayment} {$currency->sign}</div>
                    <div class="text-center">
                        <button class="button_green convert-payments">Защитать в бонусы</button>
                        <button class="button_green dont-convert-payments">Не защитатывать</button>
                    </div>
                </div>
            </div>
        {/if}
        <!-- Форма статуса: -->
        {if $showStatusDialog && $rentsCount > 0}
            <div id="statuses-dialog" class="window">
                {*<a href="#" class="close">X</a>*}
                <h2 class="header no-float">Выберите статусы для товаров</h2>
                <div class="content">
                    <table border="0">
                        {foreach from=$purchases item=purchase}
                            {if $purchase->rent == 1}
                                <tr class="item">
                                    <td class="item-name">{$purchase->product_name} (арт. {$purchase->variant->sku}) <input type="hidden" name="variant_id" value="{$purchase->variant->id}"></td>
                                    <td class="item-status text-right">
                                        <select name="status_id">
                                            {foreach $variantsStatuses as $status}
                                                {if $status->disable_manual != 1}
                                                    <option value="{$status->id}" data-require-days="{$status->require_days}" {if $status->is_cleaning == 1}selected{/if}>{$status->name}</option>
                                                {/if}
                                            {/foreach}
                                        </select>
                                        <select name="status_days" style="display: none;">
                                            {section name=days start=0 loop=30 step=1}
                                                <option value="{$smarty.section.days.index}">
                                                    {$smarty.section.days.index}
                                                    {if $smarty.section.days.index == 1}день{else}{if $smarty.section.days.index > 1 and $smarty.section.days.index < 5}дня{else}дней{/if}{/if}
                                                </option>
                                            {/section}
                                        </select>
                                        <select name="dry_cleaning" style="display: none;">
                                            <option value="">Химчистка</option>
                                            <option value="KIMS" {if $variant->dry_cleaning == 'KIMS'}selected{/if}>KIMS</option>
                                            <option value="ЦЕХ" {if $variant->dry_cleaning == 'ЦЕХ'}selected{/if}>ЦЕХ</option>
                                            <option value="TWIST" {if $variant->dry_cleaning == 'TWIST'}selected{/if}>TWIST</option>
                                            <option value="Другое" {if $variant->dry_cleaning == 'Другое'}selected{/if}>Другое</option>
                                        </select>
                                    </td>
                                </tr>
                            {/if}
                        {/foreach}
                        <tr>
                            <td colspan="3" class="update text-center">
                                <button class="button_green update-btn">Сохранить</button>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        {/if}
        {if $blockedInfo}
            <div id="blocked-info-dialog" class="window">
                {*<a href="#" class="close">X</a>*}
                <h2 class="header no-float">Блокировка товаров</h2>
                <div class="content">
                    <table border="0">
                        <tr>
                            <th>Вариант</th>
                            <th>дата блокировки</th>
                            <th>заказ</th>
                            <th>описание</th>
                            <th>установлено</th>
                        </tr>
                        {foreach from=$blockedInfo key=variantId item=blockedInfoItem}
                            <tr class="item-head">
                                <td class="item-sku" colspan="6">арт. {$variantId} <input type="hidden" name="variant_id" value="{$variantId}"></td>
                            </tr>
                            {foreach $blockedInfoItem as $dateBlocked}
                                <tr class="item-info">
                                    <td class="item-sku">&nbsp;<input type="hidden" class="blocked-id" value="{$dateBlocked->id}"></td>
                                    <td class="item-date-blocked">
                                        {$dateBlocked->dates_blocked}
                                    </td>
                                    <td class="item-order">
                                        {if $dateBlocked->order_id && $dateBlocked->order_id != ''}Заказ #{$dateBlocked->order_id}{/if}
                                    </td>
                                    <td class="item-note">
                                        {$dateBlocked->note}
                                    </td>
                                    <td class="item-modified text-right">
                                        {$dateBlocked->modified}
                                    </td>
                                    <td class="item-modified text-right">
                                        <button class="button_green unblock">Разблокировать</button>
                                    </td>
                                </tr>
                            {/foreach}
                        {/foreach}
                    </table>
                    <button class="button_green float-right close-dialog">Закрыть</button>
                </div>
            </div>
        {/if}
        <div id="mask"></div>
    </div>
{/capture}

{* On document load *}
{literal}
    <script src="design/js/autocomplete/jquery.autocomplete-min.js"></script>
    <style>
        .autocomplete-w1 {
            background: no-repeat bottom right;
            position: absolute;
            top: 0px;
            left: 0px;
            margin: 6px 0 0 6px; /* IE6 fix: */
            _background: none;
            _margin: 1px 0 0 0;
        }

        .autocomplete {
            border: 1px solid #999;
            background: #FFF;
            cursor: default;
            text-align: left;
            overflow-x: auto;
            min-width: 300px;
            overflow-y: auto;
            margin: -6px 6px 6px -6px; /* IE6 specific: */
            _height: 350px;
            _margin: 0;
            _overflow-x: hidden;
        }

        .autocomplete .selected {
            background: #F0F0F0;
        }

        .autocomplete div {
            padding: 2px 5px;
            white-space: nowrap;
        }

        .autocomplete strong {
            font-weight: normal;
            color: #3399FF;
        }
    </style>

<script>
    $(function () {

        //vikup
        $('.popup-close').click(function() {
            $(this).parents('.popup-fade').fadeOut();
            return false;
        });
        // Закрытие по клавише Esc.
        $(document).keydown(function(e) {
            if (e.keyCode === 27) {
                e.stopPropagation();
                $('.popup-fade').fadeOut();
            }
        });
        $('.popup-fade').click(function(e) {
            if ($(e.target).closest('.popup').length == 0) {
                $(this).fadeOut();
            }
        });
        $('.popup-close_').click(function() {
            $(this).parents('.popup-fade').fadeOut();
            return false;
        });

        // For prom:
        $('#for-prom').change(function () {
            $('.for-prom').toggle();
        });
        var autocompleteSchoolName;
        $("#school-city").change(function () {
            $("#school-name").autocomplete("destroy");
            $("#school-name").removeData('autocomplete');
            if (autocompleteSchoolName != undefined) {
                autocompleteSchoolName.options.params = {action: 'autocomplete-school-name', school_city: $("#school-city").val()};
            }
        }).trigger('change');

        autocompleteSchoolName = $("#school-name").autocomplete({
            serviceUrl: 'ajax/ajax_orders.php',
            minChars: 0,
            onKeyUp: function (b) {
            },
            noCache: true,
            deferRequestBy: 300,
            params: {action: 'autocomplete-school-name', school_city: $("#school-city").val()},
            onSelect: function (value, data) {

            },
        });

        $("#school-city").autocomplete({
            serviceUrl: 'ajax/ajax_orders.php',
            minChars: 0,
            onKeyUp: function (b) {
            },
            noCache: false,
            deferRequestBy: 300,
            params: {action: 'autocomplete-school-city'},
            onSelect: function (value, data) {
                $('#school-city').trigger('change');
            },
        });

        function number_format(number, decimals, dec_point, thousands_sep) {
            number = (number + '')
                .replace(/[^0-9+\-Ee.]/g, '');
            var n = !isFinite(+number) ? 0 : +number,
                prec = !isFinite(+decimals) ? 0 : Math.abs(decimals),
                sep = (typeof thousands_sep === 'undefined') ? ',' : thousands_sep,
                dec = (typeof dec_point === 'undefined') ? '.' : dec_point,
                s = '',
                toFixedFix = function (n, prec) {
                    var k = Math.pow(10, prec);
                    return '' + (Math.round(n * k) / k).toFixed(prec);
                };
            // Fix for IE parseFloat(0.55).toFixed(0) = 0;
            s = (prec ? toFixedFix(n, prec) : '' + Math.round(n)).split('.');
            if (s[0].length > 3) {
                s[0] = s[0].replace(/\B(?=(?:\d{3})+(?!\d))/g, sep);
            }
            if ((s[1] || '')
                .length < prec) {
                s[1] = s[1] || '';
                s[1] += new Array(prec - s[1].length + 1)
                    .join('0');
            }
            return s.join(dec);
        }

        $(document).ready(function () {
            $('.order-managers').change(function () {
                var cityId = parseInt($(this).find('option:selected').attr('data-city-id'));
                if (isNaN(cityId) || cityId <= 0) {
                    cityId = 1;
                }
                $('.order_city_id').val(cityId);
                recalculate();
            });

            $('.for-employee-wrapper').click(function (event) {
                event.stopPropagation();
                event.preventDefault();

                //Заказ на сотрудника
                $(this).data('for_employee') == 1 ? $(this).data('for_employee', 0) : $(this).data('for_employee', 1);
                recalculate();

                var input = $(this).find('input');
                input.prop('checked', !input.prop('checked')).trigger('change');
                if (input.prop('checked')) {
                    $('.for-partner-wrapper input').prop('checked', false).trigger('change');
                }
            });
            $('.for-partner-wrapper').click(function (event) {
                event.stopPropagation();
                event.preventDefault();
                var input = $(this).find('input');
                input.prop('checked', !input.prop('checked')).trigger('change');
                if (input.prop('checked')) {
                    $('.for-employee-wrapper input').prop('checked', false).trigger('change');
                }
            });

            $('input[name="prepayment"]').change(function () {
                var value = parseFloat($(this).val());
                var alreadyPayed = parseFloat($('.already-paid').data('value'));
                var totalSum = parseFloat($('#sum_total').data('value'));
                if (!isNaN(totalSum) && !isNaN(alreadyPayed) && !isNaN(value)) {
                    if (value + alreadyPayed >= totalSum && !($('#paid').is(':checked'))) {
                        if (confirm('Заказ оплачен?')) {
                            $('#paid').prop('checked', true).trigger('change');
                        }
                    }
                }

            });

            // Blcoked dialog:
            var blcokedDialog = $('#blocked-info-dialog');
            if (blcokedDialog.length > 0) {
                var maskHeight = $(document).height();
                var maskWidth = $(window).width();
                $('#mask').css({'width': maskWidth, 'height': maskHeight}).fadeTo(100, 0.5);
                var winH = $(window).height();
                var winW = $(window).width();
                var scrollV = $(document).scrollTop();
                blcokedDialog.css('top', 150 + scrollV);
                blcokedDialog.css('left', winW / 2 - blcokedDialog.width() / 2);
                blcokedDialog.fadeIn(100);

                $('#blocked-info-dialog .close-dialog').click(function () {
                    $('#mask, .window').hide();
                });

                $('#blocked-info-dialog .unblock').click(function () {
                    var blockId = parseInt($(this).closest('.item-info').find('.blocked-id').val());
                    if (!isNaN(blockId) && blockId > 0) {
                        var self = $(this);
                        $.ajax({
                            url: 'ajax/ajax_variants.php',
                            type: 'post',
                            dataType: 'json',
                            data: {action: 'unblock-forcibly', block_id: blockId, order_id: $('.order-id').val()},
                            success: function (response) {
                                if (response && response.success) {
                                    self.after('Разблокировано');
                                    self.remove();
                                } else {
                                    alert('Ошибка');
                                }
                            },
                        });
                    }
                });
            }

            // Payments conversion dialog:
            var convertPaymentsDialog = $('#payments-convert-dialog');
            if (convertPaymentsDialog.length > 0) {
                var maskHeight = $(document).height();
                var maskWidth = $(window).width();
                $('#mask').css({'width': maskWidth, 'height': maskHeight}).fadeTo(100, 0.5);
                var winH = $(window).height();
                var winW = $(window).width();
                var scrollV = $(document).scrollTop();
                convertPaymentsDialog.css('top', winH / 2 - 50 + scrollV);
                convertPaymentsDialog.css('left', winW / 2 - convertPaymentsDialog.width() / 2);
                convertPaymentsDialog.fadeIn(100);

                $('.convert-payments').click(function (event) {
                    event.preventDefault();
                    var self = $(this);
                    $.ajax({
                        url: 'ajax/ajax_orders.php',
                        type: 'post',
                        dataType: 'json',
                        data: {action: 'convert-payment-to-bonuses', order_id: $('.order-id').val(), manager: $('.order-managers').val()},
                        success: function (response) {
                            if (response && response.success) {
                                alert('Бонусы зачислены.');
                                $('#mask, .window').hide();
                            } else {
                                alert('Ошибка');
                            }
                        },
                    });
                });

                $('.dont-convert-payments').click(function (event) {
                    $('#mask, .window').hide();
                });
            }
            // Statuses dialog:
            var statusDialog = $('#statuses-dialog');
            if (statusDialog.length > 0) {
                var maskHeight = $(document).height();
                var maskWidth = $(window).width();
                $('#mask').css({'width': maskWidth, 'height': maskHeight}).fadeTo(100, 0.5);
                var winH = $(window).height();
                var winW = $(window).width();
                var scrollV = $(document).scrollTop();
                statusDialog.css('top', winH / 2 - 50 + scrollV);
                statusDialog.css('left', winW / 2 - statusDialog.width() / 2);
                statusDialog.fadeIn(100);

                $('.window .close').click(function (e) {
                    // e.preventDefault();
                    // $('#mask, .window').hide();
                });
                $('#mask').click(function () {
                    // $(this).hide();
                    // $('.window').hide();
                });
                $(document).on('change', 'select[name*=status_days]', function () {
                    var row = $(this).closest('.item');
                    if (row.length > 0) {
                        var variantId = parseInt(row.find('input[name*=variant_id]').val());
                        var days = parseInt($(this).val());
                        if (!isNaN(days) && !isNaN(variantId) && days > 0 && variantId > 0) {
                            var now = new Date();
                            var startDate = now.getFullYear() + '-' + (now.getMonth() + 1) + '-' + now.getDate();
                            checkVariantAvailable(variantId, startDate, days);
                        }
                    }
                });
                $(document).on('change', 'select[name*=status_id]', function () {
                    if (parseInt($(this).find(':selected').attr('data-require-days')) == 1) {
                        var row = $(this).closest('.item');
                        if (row.length > 0) {
                            var self = $(this);
                            var variantId = parseInt(row.find('input[name*=variant_id]').val());
                            $.ajax({
                                url: 'ajax/ajax_variants.php',
                                type: 'post',
                                dataType: 'json',
                                data: {action: 'get-unblocked-period', variant_id: variantId},
                                success: function (response) {
                                    if (response && response.success) {
                                        var days = response.days;
                                        var statusDays = self.closest('.item').find('select[name*=status_days]');
                                        statusDays.find('option').prop('disabled', true);
                                        statusDays.find('option').slice(0, days + 1).prop('disabled', false);
                                        if (days >= 1) {
                                            statusDays.find('option[value="1"]').prop('selected', true);
                                        }
                                        statusDays.show().focus().trigger('change');

                                        if (self.val() == 3) {
                                            self.closest('.item').find('select[name*=dry_cleaning]').show();
                                        }
                                    }
                                },
                            });
                        } else {
                            $(this).closest('.item').find('select[name*=status_days]').show().focus().trigger('change');
                            $(this).closest('.item').find('select[name*=dry_cleaning]').show();
                        }
                    } else {
                        $(this).closest('.item').find('select[name*=status_days]').hide().find('option:selected').prop('selected', false);
                        $(this).closest('.item').find('select[name*=dry_cleaning]').hide().find('option:selected').prop('selected', false);
                    }
                });
                $.each($(document).find('option[data-require-days="1"]'), function (key, item) {
                    if ($(item).is(':selected')) {
                        $(item).closest('select').trigger('change');
                    }
                });

                function checkVariantAvailable(variantId, startDate, daysCount) {
                    $.ajax({
                        url: 'ajax/ajax_variants.php',
                        type: 'post',
                        dataType: 'json',
                        data: {action: 'is_variant_blocked_for_orders', variant_id: variantId, start_date: startDate, days_count: daysCount},
                        success: function (response) {
                            if (response && response.success) {
                                if (response.is_reserved) {
                                    alert("Товар заблокирован заказом на выбраный период");
                                }
                            }
                        },
                    });
                }

                $('.update-btn').click(function () {
                    var params = [];
                    $.each(statusDialog.find('.item'), function (key, item) {
                        if ($(item).find('[name="status_id"]').val() == 3) {
                            params.push({
                                variant_id: $(item).find('[name="variant_id"]').val(),
                                status_id: $(item).find('[name="status_id"]').val(),
                                status_days: $(item).find('[name="status_days"]').val(),
                                order_id: $('.order-id').val(),
                                dry_cleaning: $(item).find('select[name=dry_cleaning]').val(),
                                action: 'setDryCleaning',
                            });
                        } else {
                            params.push({
                                variant_id: $(item).find('[name="variant_id"]').val(),
                                status_id: $(item).find('[name="status_id"]').val(),
                                status_days: $(item).find('[name="status_days"]').val(),
                                order_id: $('.order-id').val(),
                            });
                        }
                    });
                    if (params.length > 0) {
                        $.ajax({
                            url: 'ajax/ajax_variants.php',
                            type: 'post',
                            dataType: 'json',
                            data: {action: 'update-variants-statuses', data: params},
                            success: function (response) {
                                if (response && response.success) {
                                    $('#mask, .window').hide();
                                } else {
                                    alert("Ошибка при обновлении статусов.");
                                    $.each($(document).find('option[data-require-days="1"]'), function (key, item) {
                                        if ($(item).is(':selected')) {
                                            $(item).closest('select').trigger('change');
                                        }
                                    });
                                }
                            },
                        });
                    }
                });
            }
        });

        $(".user-exclamation").mouseover(function () {
            $(".exclamation-tooltip").show();
        }).mouseout(function () {
            $(".exclamation-tooltip").hide();
        }).click(function (event) {
            event.preventDefault();
        });

        recalculate();
        // Original JavaScript code by Chirp Internet: www.chirp.com.au
        // Please acknowledge use of this code by including this header.
        function checkDate(field) {
            var allowBlank = true;
            var minYear = 1902;
            var maxYear = (new Date()).getFullYear() + 1;
            var errorMsg = ""; // regular expression to match required date format
            re = /^(\d{4})-(\d{1,2})-(\d{1,2})$/;
            if (field.val() != '') {
                if (regs = field.val().match(re)) {
                    if (regs[3] < 1 || regs[3] > 31) {
                        errorMsg = "Invalid value for day: " + regs[3];
                    } else if (regs[2] < 1 || regs[2] > 12) {
                        errorMsg = "Invalid value for month: " + regs[2];
                    } else if (regs[1] < minYear || regs[1] > maxYear) {
                        errorMsg = "Invalid value for year: " + regs[1] + " - must be between " + minYear + " and " + maxYear;
                    }
                } else {
                    errorMsg = "Invalid date format: " + field.val();
                }
            } else if (!allowBlank) {
                errorMsg = "Empty date not allowed!";
            }
            if (errorMsg != "") {
                alert(errorMsg);
                field.focus();
                return false;
            }
            return true;
        }

        $('select[name="delivery_id"]').change(function () {
            var price = parseFloat($(this).find('option:selected').data('price'));
            var separatePayment = parseInt($(this).find('option:selected').data('separate-payment'));
            if (!isNaN(price)) {
                $('input[name="delivery_price"]').val(toFixed(price, 0));
                recalculate();
            }
            if (!isNaN(separatePayment) && separatePayment > 0) {
                $("#separate_delivery").attr('checked', 'checked').trigger('change');
                recalculate();
            } else {
                $("#separate_delivery").removeAttr('checked').trigger('change');
                recalculate();
            }
        }).trigger('change');

        function toFixed(value, precision) {
            var precision = precision || 0,
                power = Math.pow(10, precision),
                absValue = Math.abs(Math.round(value * power)),
                result = (value < 0 ? '-' : '') + String(Math.floor(absValue / power));

            if (precision > 0) {
                var fraction = String(absValue % power),
                    padding = new Array(Math.max(precision - fraction.length, 0) + 1).join('0');
                result += '.' + padding + fraction;
            }
            return result;
        }

        $('.button_submit').live('click', function (event) {

            var paymentLeft = parseInt($('#sum_with_prepayment b').text());
            var orderStatus = parseInt($(".status").val());

            if (orderStatus == 2 && paymentLeft != 0) {
                alert("Необходимо откорректировать оплату в заказе");
                return;
            }

            $(".row").each(function () {
                var startDate = $(this).find('.product_date');
                var alt = $(startDate).next();
                var rent = $(this).find('select[name*=rent]');
                if (rent.val() == '1' && !checkDate(alt)) {
                    alert("Wrong data format.");
                    return;
                }
            });
            var alreadyPayed = parseFloat($('#prepayment').val());
            var prepayment = parseFloat($('input[name="prepayment"]').val());
            if ($('select[name="status"]').val() == 0 && (alreadyPayed > 0 || prepayment > 0)) {
                alert("Выберите правильний статус");
                return;
            }
            if ($("#list.purchases").find('.row').length <= 0) {
                alert("Заказ должен местить хотя бы один товар");
                return;
            }
            if ($("input[name*=user_id]").val().length == 0) {
                alert("Не выбран пользователь");
                return;
            }
/////////////////////////////////////////////////////////////////////////////////////
            // проверка на существование не завершенных заказов на выбранную подписку
            //console.log({action: 'CheckOrderWithSubscriptionId', uid: $('input[name="user_id"]').val(), subscriptionId:$('select[name="subscription_id"]').val()});
            $.ajax({
                    url: 'ajax/subscriptions_ajax.php',
                    async: false,
                    type: 'post',
                    dataType: 'json',
                    data: {action: 'CheckOrderWithSubscriptionId', uid: $('input[name="user_id"]').val(), subscriptionId:$('select[name="subscription_id"]').val()},
                    success: function (response) {
                        if (response) {
                            // console.log(response);
                            if(response.length>0){
                                for (var i in response) {
                                    if(response[i].id !==$('.order-id').val()) {
                                        $("input[name*=subscription_id]").val(response[i].id);
                                    } else {
                                        $("input[name*=subscription_id]").val('');
                                    }
                                }
                            } else {
                                $("input[name*=subscription_id]").val('');
                            }
                        }
                    }
            });

            /////////////////////////////////////////////////////////////////////////////////////
            // TODO также закреплен ли этот товар за данной подпиской
           $.ajax({
               url: 'ajax/subscriptions_ajax.php',
               type: 'post',
               dataType: 'json',
               async: false,
               data: {action: 'CheckProductWithSubscriptionId', uid: $('input[name="user_id"]').val(), subscriptionId:$('select[name="subscription_id"]').val()},
               success: function (response) {
                   if (response) {
                       var is_in_response = new Array();
                       var purchases_id = new Array();
                       $.each($('.purchases').find('.row'), function (key, row) {
                           console.log(row);
                           purchases_id.push($('select[name*=purchases][name*=variant_id]').val());
                       });
                       console.log(purchases_id);

                       for (var i in response) {
                           console.log(response[i]['sku']);
                           if(purchases_id.indexOf(response[i]['sku'])){//если есть в массиве разрешенных
                               is_in_response.push(response[i]['sku']);
                               $("input[name*=subscription_products]").val('');
                           } else {
                               $("input[name*=subscription_products]").val(response[i]['sku']);
                           }
                       }
                   }
               }
           });
            //проверка на количество предметов в заказе соответсвует ли оно разрешенному количству в подписке
            $.ajax({
                url: 'ajax/subscriptions_ajax.php',
                type: 'post',
                dataType: 'json',
                async: false,
                data: {action: 'CheckProductCountWithSubscriptionId', uid: $('input[name="user_id"]').val(), subscriptionId:$('select[name="subscription_id"]').val()},
                success: function (response) {
                    if (response) {
                        console.log(response);
                        var k=0;
                        $.each($('.purchases').find('.row'), function (key, row) {
                            k++
                        });


                        var count=0;
                        for (var i in response) {
                            count =response[i].products;
                            console.log('count='+count);
                            console.log('rows='+k);
                            if(k>count){
                                $("input[name*=subscription_count_products]").val(response[i].id);
                            } else {
                                $("input[name*=subscription_count_products]").val('');
                            }
                        }
                    }
                }
            });
            /////////////////////////////////////////////////////////////////////////////////////


            if ($("input[name*=subscription_id]").val().length != 0) {
                console.log($("input[name*=subscription_id]").val());
                alert('У Вас есть незавершенный заказ №' +$("input[name*=subscription_id]").val() + ' с подпиской.');
                return;
            }
            if ($("input[name*=subscription_count_products]").val().length != 0) {
                console.log($("input[name*=subscription_count_products]").val());
                alert('Количество выбранных Вами товаров не совпадает с разрешенным для данной подписки.');
                return;
            }
            if ($("input[name*=subscription_products]").val().length != 0) {
                console.log($("input[name*=subscription_products]").val());
                alert('Выбранных Вами товаров нет в данной подписке.');
                return;
            }
/////////////////////////////////////////////////////////////////////////////////////



            if (orderStatus != 3) {
                if (document.getElementById('rent_reason').value == 0) {
                    alert("Не выбран повод");
                    return;
                }
                if ((document.getElementById('rent_reason').value == 25) && $("input[name*=other_reason]").val().length == 0) {
                    alert("Не выбран повод");
                    return;
                }
                if (document.getElementById('how_know').value == 0) {
                    alert("Не выбран источник ");
                    return;
                }
                if ((document.getElementById('how_know').value == 25) && $("input[name*=other_how_know]").val().length == 0) {
                    alert("Не выбран источник ");
                    return;
                }
            }

            if (parseInt($('#manager-present').val()) == 0 && $('select.order-managers option:selected').val().length == 0) {
                alert("Не выбран Менеджер");
                return;
            }
            if (parseInt($(".order-status").val()) != parseInt($(".status").val()) && parseInt($(".status").val()) == 2 && !$("#paid").is(":checked")) {
                if (!window.confirm("Вы закрываете заказ без получения всей оплаты! Чтобы изменить нажмите Отмена, или Ок для сохранения заказа без оплаты")) {
                    return;
                }
            }
            var returnVar = false;
            $.each($('.purchases').find('.row'), function (key, row) {
                var isRent = $(row).find('.is-rent').val();
                if (isRent == 1) {
                    var startDateInput = $(row).find('.product_date');
                    if (startDateInput.next().val().length <= 0) {
                        alert("Не указана дата начала аренды");
                        startDateInput.datepicker("show");
                        returnVar = true;
                        return;
                    }
                }
            });
            if (returnVar) {
                return;
            }
            $('form').submit();
        });
//    $('.button_save').live('click', function() {
//        $(".row").each(function(){
//            var startDate = $(this).find('.product_date');
//            var alt = $(startDate).next();
//            var rent = $(this).find('select[name*=rent]');
//            if(rent.val() == '1' && !checkDate(alt)){
//                alert("Wrong data format.");
//                return ;
//            }
//        });
//        if($("input[name*=user_id]").val().length == 0){
//            alert("Не выбран пользователь");
//            return ;
//        }
//
//        if(parseInt($('#manager-present').val()) == 0 && $('select.order-managers option:selected').val().length == 0){
//            alert("Не выбран Менеджер");
//            return ;
//        }
//        $('form').submit();
//    });
        // Раскраска строк
        function colorize() {
            $("#list div.row:even").addClass('even');
            $("#list div.row:odd").removeClass('even');
        }

        // Раскрасить строки сразу
        colorize();

        // Удаление товара
        $(".purchases a.delete").live('click', function () {
            $(this).closest(".row").fadeOut(200, function () {
                $(this).remove();
                recalculate();
            });
            return false;
        });
        $('select[name*=purchases][name*=amount]').each(function () {
            $(this).data('lastValue', $(this).val());
        });
        $('select[name*=purchases][name*=amount]').change(function () {
            var self = $(this);
            validateForReserved($(this), function (isReserved) {
                if (isReserved) {
                    // self.val(self.data('lastValue'));
                    self.val('');
                } else {
                    self.data('lastValue', self.val());
                    recalculate();
                }
            });
        });
        $('.prepayment input').change(function () {
            recalculate();
        });
        // Аренда товара
        $(".purchases .is-rent").live('change', function () {
            var rent_val = $(this).val();
            var variants_select = $(this).closest(".row").find('select[name*=purchases][name*=variant_id]');
            var sellersPrice = $(this).closest('.row').find('span.sellersPriceText');
            var amount = $(this).closest('.row').find('select[name*=purchases][name*=amount]');
            if (rent_val == '1') {
                sellersPrice.hide();
                var startDate = $(this).closest(".row").find('.product_date');
                startDate.val(startDate.data('lastValue'));
                startDate.show();
                change_variant(variants_select);
            }  else if (rent_val == '3') {
                sellersPrice.hide();
                $('.popup-fade').show();
            } else if (rent_val == '4') {
                sellersPrice.hide();
            } else {
                var orderID = $('input[name="id"]').val();
                var self = $(this);
                $.ajax({
                    type: 'POST',
                    url: 'ajax/ajax_variants.php',
                    data: {id: variants_select.val(), action: 'check_variant_blocked', order_id: orderID},
                    dataType: 'json',
                    success: function (data) {
                        if (data.success) {
                            if (!data.reserved) {
                                sellersPrice.show();
                                var startDate = self.closest(".row").find('.product_date');
                                startDate.data('lastValue', startDate.val());
                                startDate.val('');
                                startDate.hide();
                                amount.show();
                                change_variant(variants_select);
                            } else {
                                alert('Даное платье уже забронировано на будущее.');
                            }
                        }
                    },
                });
            }


            $('.edit_purchases').trigger('click');
        });
        // Добавление товара
        var new_purchase = $('.purchases #new_purchase').clone(false);
        $('.purchases #new_purchase').remove().removeAttr('id');

        function uniqId() {
            return Math.round(new Date().getTime() + (Math.random() * 100));
        }


        var autocompleteSertificate = $("#findSertificateCode").autocomplete({
            serviceUrl: 'ajax/certificateAutocomplete.php',
            minChars: 0,
            onKeyUp: function (b) {
            },
            noCache: false,
            deferRequestBy: 300,
            params: {},
            onSelect: function (value, data) {
                var units = (data.type == 'absolute') ? 1 : 0;
                $(".certificate").show();
                $('#sertificateCode').val(data.id);
                $('#sertificateUnits').val(units);
                $('#sertificateValue').val(parseFloat(data.value));
                $('#certificateOutput').html(data.text);
                recalculate();
            },
        });

        autocompleteSertificate.enable();

        $(".delete_certificate").click(function () {
            $(".certificate").hide();
            $('#sertificateUnits').val('');
            $('#sertificateCode').val('');
            $('#sertificateValue').val('');
            $('#certificateOutput').html('');
            recalculate();
        });

        $("input#add_purchase").autocomplete({
            serviceUrl: 'ajax/add_order_product.php',
            minChars: 0,
            noCache: true,
            onSelect:
                function (value, data) {
                    new_item = new_purchase.clone().appendTo('.purchases');
                    var startDate = new_item.find('input.product_date').removeClass('hasDatepicker');
                    startDate.attr('id', 'dp' + uniqId());
                    var alt = $(startDate).next();
                    alt.attr('id', 'alt_date_' + startDate.attr('id'));
                    var variant = startDate.closest(".row").find('select[name*=purchases][name*=variant_id]');
                    var currentField = startDate;
                    startDate.datepicker({
                        changeMonth: true,
                        dateFormat: "dd.mm.yy",
                        numberOfMonths: 1,
                        showAnim: 'fadeIn',
                        minDate: 0,
                        onSelect: function (date, inst) {
                            validateForReserved(startDate, function (isReserved) {
                                if (isReserved) {
                                    if (startDate.data('lastValue') != undefined) {
                                        // startDate.val(startDate.data('lastValue'));
                                        // alt.val(jQuery.datepicker.formatDate('yy-mm-dd', parseDate(startDate.data('lastValue'), 'dd.mm.yyyy')));
                                        startDate.val('');
                                        alt.val('');
                                    } else {
                                        startDate.val('');
                                        alt.val('');
                                    }
                                } else {
                                    startDate.data('lastValue', startDate.val());
                                }
                            });
                        },
                        beforeShow: function (inpput, inst) {
                            var variantID = variant.val();
                            var orderId = $('input[name="id"]').val();
                            $.ajax({
                                type: 'POST',
                                url: 'ajax/get_variant_blocked_data.php',
                                data: {'varID': variantID, 'action': 'getBlockedData', 'order_id': orderId},
                                dataType: 'json',
                                success: function (data) {
                                    currentField.data('disabledDates', data);
                                    currentField.datepicker("refresh");
                                },
                                error: function (data) {
                                },
                            });

                        },
                        beforeShowDay: function (date) {
                            var string = jQuery.datepicker.formatDate('yy-mm-dd', date);
                            var array = [];
                            if (currentField.data('disabledDates')) {
                                array = currentField.data('disabledDates');
                            }
                            string = jQuery.datepicker.formatDate('yy-mm-dd', date);
                            return [array.indexOf(string) == -1]
                        },
                        altFormat: "yy-mm-dd",
                        altField: '#' + alt.attr('id'),
                    });
                    new_item.removeAttr('id');
                    new_item.find('a.purchase_name').html(data.name);
                    new_item.find('a.purchase_name').attr('href', 'index.php?module=ProductAdmin&id=' + data.id);
                    new_item.bind('change', function () {
                        recalculate();
                    });
                    // Добавляем варианты нового товара
                    var variants_select = new_item.find('select[name*=purchases][name*=variant_id]');
                    for (var i in data.variants) {
                        variants_select.append("<option data-owner_bonus_percent='" + data.variants[i].bonus_value + "' data-is_accessory='" + data.variants[i].isAccessory + "' data-owner_id='" + data.variants[i].ownerId + "' value='" + data.variants[i].id + "' city_id='" + data.variants[i].city_id + "' not_for_sale='" + data.variants[i].not_for_sale + "'  sellers_price='" + data.variants[i].sellers_price + "' price='" + data.variants[i].price + "' compare_price='" + data.variants[i].compare_price + "' amount='" + data.variants[i].stock + "' size='" + data.variants[i].size + "' cash_bonus='" + data.variants[i].cash_bonus + "'>( арт." + data.variants[i].sku + ")</option>");
                    }

                    var amount_select = new_item.find('select[name*=purchases][name*=amount]');
                    amount_select.bind('change', function () {
                        var self = $(this);
                        validateForReserved($(this), function (isReserved) {
                            if (isReserved) {
                                // self.val(self.data('lastValue'));
                                self.val('');
                                alt.val('');
                            } else {
                                self.data('lastValue', self.val());
                                recalculate();
                            }
                        });
                    });
                    variants_select.bind('change', function () {
                        change_variant(variants_select);
                    });

                    var variants_size = new_item.find('select[name*=purchases][name*=size_id]');
                    new_item.find('span.sellersPriceText').html('<br >' + data.variants[0].sellers_price);
                    for (var i in data.variants) {
                        var size_text = '';
                        switch (data.variants[i].size) {
                        {/literal}
                        {foreach from=$sizes_active item=size_active}
                            case '{$size_active->id}':
                                size_text = "{$size_active->size}";
                                break;
                        {/foreach}
                        {literal}
                            default:
                                size_text = "Не указан";
                                break;
                        }
                        variants_size.append("<option value='" + data.variants[i].size + "'>" + size_text + "</option>");
                    }
                    change_variant(variants_select);

                    if (data.image) {
                        new_item.find('img.product_icon').attr("src", data.image);
                    } else {
                        new_item.find('img.product_icon').remove();
                    }

                    $("input#add_purchase").val('');
                    var rent_anchor = new_item.find('.is-rent');
                    rent_anchor.trigger('change');
                    new_item.show();
                    recalculate();
                },
            fnFormatResult:
                function (value, data, currentValue) {
                    var reEscape = new RegExp('(\\' + ['/', '.', '*', '+', '?', '|', '(', ')', '[', ']', '{', '}', '\\'].join('|\\') + ')', 'g');
                    var pattern = '(' + currentValue.replace(reEscape, '\\$1') + ')';
                    return (data.image ? "<img align=absmiddle src='" + data.image + "'> " : '') + value.replace(new RegExp(pattern, 'gi'), '<strong>$1<\/strong>');
                },

        });

        $("input#add_purchase_by_barcode").on('keypress', function (e) {
            var code = e.keyCode || e.which;
            if (code == 13 || e.which === 9) {
                var text = $(this).val();
                $(this).val('');
                $.ajax({
                    type: 'POST',
                    url: 'ajax/add_order_product_by_barcode.php',
                    data: {'text': text, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
                    success: function (data) {
                        if (data['data'] != null) {
                            var data_s = data['data']['0'];
                            new_item = new_purchase.clone().appendTo('.purchases');
                            var startDate = new_item.find('input.product_date').removeClass('hasDatepicker');
                            startDate.attr('id', 'dp' + uniqId());
                            var alt = $(startDate).next();
                            alt.attr('id', 'alt_date_' + startDate.attr('id'));
                            var variant = startDate.closest(".row").find('select[name*=purchases][name*=variant_id]');
                            var currentField = startDate;
                            startDate.datepicker({
                                minDate: 0,
                                changeMonth: true,
                                dateFormat: "dd.mm.yy",
                                numberOfMonths: 1,
                                showAnim: 'fadeIn',
                                beforeShow: function (inpput, inst) {
                                    var variantID = variant.val();
                                    var orderId = $('input[name="id"]').val();
                                    $.ajax({
                                        type: 'POST',
                                        url: 'ajax/get_variant_blocked_data.php',
                                        data: {'varID': variantID, 'action': 'getBlockedData', 'order_id': orderId},
                                        dataType: 'json',
                                        success: function (data) {
                                            currentField.data('disabledDates', data);
                                            currentField.datepicker("refresh");
                                        },
                                        error: function (data) {

                                        },
                                    });

                                },
                                beforeShowDay: function (date) {
                                    var string = jQuery.datepicker.formatDate('yy-mm-dd', date);
                                    var array = [];
                                    if (currentField.data('disabledDates')) {
                                        array = currentField.data('disabledDates');
                                    }
                                    string = jQuery.datepicker.formatDate('yy-mm-dd', date);
                                    return [array.indexOf(string) == -1]
                                },
                                onSelect: function (date, inst) {
                                    validateForReserved(startDate, function (isReserved) {
                                        if (isReserved) {
                                            if (startDate.data('lastValue') != undefined) {
                                                // startDate.val(startDate.data('lastValue'));
                                                // alt.val(jQuery.datepicker.formatDate('yy-mm-dd', parseDate(startDate.data('lastValue'), 'dd.mm.yyyy')));
                                                startDate.val('');
                                                alt.val('');
                                            } else {
                                                startDate.val('');
                                                alt.val('');
                                            }
                                        } else {
                                            startDate.data('lastValue', startDate.val());
                                        }
                                    });
                                },
                                altFormat: "yy-mm-dd",
                                altField: '#' + alt.attr('id'),
                            });
                            new_item.removeAttr('id');
                            new_item.find('a.purchase_name').html(data_s['name']);
                            new_item.find('a.purchase_name').attr('href', 'index.php?module=ProductAdmin&id=' + data_s['id']);
                            new_item.bind('change', function () {
                                recalculate();
                            });
                            // Добавляем варианты нового товара
                            var variants_select = new_item.find('select[name*=purchases][name*=variant_id]');
                            for (var i in data_s['variants']) {
                                variants_select.append("<option data-owner_bonus_percent='" + data_s['variants'][i].bonus_value + "' data-is_accessory='" + data_s['variants'][i].isAccessory + "' data-owner_id='" + data_s['variants'][i].ownerId + "' value='" + data_s['variants'][i].id + "' not_for_sale='" + data_s.variants[i].not_for_sale + "' city_id='" + data_s.variants[i].city_id + "' sellers_price='" + data_s.variants[i].sellers_price + "' price='" + data_s['variants'][i].price + "' compare_price='" + data_s['variants'][i].compare_price + "' amount='" + data_s['variants'][i].stock + "' size='" + data_s['variants'][i].size + "'" + ((data_s['variants'][i].sku == parseInt(text)) ? 'selected' : '') + " cash_bonus='" + data_s.variants[i].cash_bonus + "'>( арт." + data_s['variants'][i].sku + ")</option>");
                            }

                            var amount_select = new_item.find('select[name*=purchases][name*=amount]');
                            amount_select.bind('change', function () {
                                var self = $(this);
                                validateForReserved($(this), function (isReserved) {
                                    if (isReserved) {
                                        // self.val(self.data('lastValue'));
                                        startDate.val('');
                                        alt.val('');
                                    } else {
                                        self.data('lastValue', self.val());
                                        recalculate();
                                    }
                                });
                            });
                            variants_select.bind('change', function () {
                                change_variant(variants_select);
                            });

                            var variants_size = new_item.find('select[name*=purchases][name*=size_id]');
                            for (var i in data_s['variants']) {
                                var size_text = '';
                                switch (data_s['variants'][i].size) {
                                {/literal}
                                {foreach from=$sizes_active item=size_active}
                                    case '{$size_active->id}':
                                        size_text = "{$size_active->size}";
                                        break;
                                {/foreach}
                                {literal}
                                    default:
                                        size_text = "Не указан";
                                        break;
                                }
                                variants_size.append("<option value='" + data_s['variants'][i].size + "'>" + size_text + "</option>");
                            }
                            change_variant(variants_select);

                            if (data_s['image']) {
                                new_item.find('img.product_icon').attr("src", data_s['image']);
                            } else {
                                new_item.find('img.product_icon').remove();
                            }

                            $("input#add_purchase").val('');
                            var rent_anchor = new_item.find('.is-rent');
                            rent_anchor.trigger('change');
                            new_item.show();
                            recalculate();
                        }
                    },
                    dataType: 'json',
                });
            }
        });

        $('select[name="status"]').change(function () {
            validatePurchases();

//            if($(this).val() == 5){
//                recalculate();
//            }

        });
        $('#price-correction-input').change(function () {
            recalculate();
        });

        $('input[name="user_id"]').on('change', function () {
            var user_id = $(this).val();

            $.ajax({
                url: 'ajax/ajax_loyalty.php',
                type: 'post',
                dataType: 'json',
                data: {action: 'getUserLoyaltyBonuses', client_id: user_id},
                success: function (response) {
                    $('#totalLoyaltyBonusesBlock').html(" (всего есть " + response + ")");
                    $('#totalLoyaltyBonuses').val(response);
                    var $loyaltyBonusesInput = $('input[name="coupon_loyalty_discount"]');
                    $loyaltyBonusesInput.prop('disabled', false);
                    $loyaltyBonusesInput.val('0');
                    recalculate();
                },
            });
        });

        function addZeros(value, len) {
            var i;

            value = "" + value;

            if (value.length < len) {
                for (i=0; i<(len-value.length); i++)
                    value = "0" + value;
            }

            return value;
        }
        // Перещет всех цен
        function recalculate() {
            var sum_variants = 0;
            var sum_variantsSale = 0;
            var sum_variantsRent = 0;
            var sum_variantsRent_ = 0;
            var discount = 0;
            var cupon = 0;
            var delivery = 0;
            var delivery_from_another_cities = 0;
            var sum_with_discount = 0;
            var sum_with_coupon_discount = 0;
            var sum_with_certificate = 0, certificate = 0;
            var sum_with_delivery = 0;
            var sum_total = 0;
            var currency = {/literal}' {$currency->sign}'{literal};
            var totalBonuses = $("#totalBonuses").val();
            var insur_val = 0;


            var priceCorrection = parseFloat($('#price-correction-input').val());
            if (isNaN(priceCorrection)) {
                priceCorrection = 0;
            }
//            console.log('PriceCorrection');
//            console.log(priceCorrection);

            var orderForEmployee = $('.for-employee-wrapper').data('for_employee');
            var cash_bonus_present = false;
            // Purchases price sum:
            $('.price input').each(function () {
                var row = $(this).closest('.row');
                var amount = row.find('select[name*=purchases][name*=amount]');
                var rent = row.find('select[name*=purchases][name*=rent]');
                var date_order = $(document).find('#created-date').val();
                var amountOption = row.find('select[name*=purchases][name*=amount] option:selected');
                if (rent.val() == '0') {
                    //var count = amount.val();
                    // 18.07.2017 Выкупить можно лишь один вариант.
                    var count = 1;//parseInt($('.amount.cell .view_purchase').text());
//                    sum_variants += (Number($(this).val()) ) * count;
                    sum_variantsSale += (Number($(this).val())) * count;
                } else if (rent.val() == '3'){
                    var count = 1;
                    sum_variantsSale += -(Number($(this).val())) * count;
                } else {
                    var old_subtotal =0;
                    var subtotal =0;
                    var month = parseInt(new Date('2020-02-13').getMonth()+1);
                    var today = new Date('2020-02-13').getFullYear()+'-'+addZeros(month,2)+'-'+new Date('2020-02-13').getDate();
//                    console.log('today'+today);

                    if(date_order && date_order<today){//old formula
//                        console.log('old formula');
                        for (var day = 1; day <= parseInt(amount.val()); day++) {
                            if (day % 2 == 1) {
                                if (orderForEmployee) {
                                    var sku = row.find('select[name*=purchases][name*=variant_id] option:selected').val();
                                    var employeePrice = 0;

                                    var itemOwnerId = parseInt($(this).attr('data-owner_id'));
                                    var itemIsAccessory = $(this).attr('data-is_accessory');
                                    var itemOwnerBonusPercent = parseInt($(this).attr('data-owner_bonus_percent')) / 100;

                                    if (itemOwnerId == 17412) {
                                        employeePrice = parseInt($(this).val()) * 0.1;
                                    } else {
                                        employeePrice = parseInt($(this).val()) * itemOwnerBonusPercent;
                                    }

                                    if (day == 1) {
                                        sum_variantsRent += employeePrice;
                                    } else if (day == 3) {
                                        sum_variantsRent += employeePrice * 0.5;
                                    } else if (day >= 5) {
                                        sum_variantsRent += employeePrice * 0.25;
                                    }
                                } else {
                                    if (day == 1) {
                                        sum_variantsRent += Number($(this).val());
                                    } else if (day == 3) {
                                        sum_variantsRent += Number($(this).val()) * 0.5;
                                    } else if (day >= 5) {
                                        sum_variantsRent += Number($(this).val()) * 0.25;
                                    }
                                }
                            }
                        }
                    } else {//new formula
                        for (var day = 1; day <= parseInt(amount.val()); day++) {
//                        if (day % 2 == 1) {
//                            console.log('new_formula');
                            if (orderForEmployee) {
                                var sku = row.find('select[name*=purchases][name*=variant_id] option:selected').val();
                                var employeePrice = 0;

                                var itemOwnerId = parseInt($(this).attr('data-owner_id'));
                                var itemIsAccessory = $(this).attr('data-is_accessory');
                                var itemOwnerBonusPercent = parseInt($(this).attr('data-owner_bonus_percent')) / 100;

                                if (itemOwnerId == 17412) {
                                    employeePrice = parseInt($(this).val()) * 0.1;
                                } else {
                                    employeePrice = parseInt($(this).val()) * itemOwnerBonusPercent;
                                }


                                switch (day) {
                                    case 1:
                                    case 2:
                                    case 3:
                                        sum_variantsRent_ = employeePrice;
                                        break;
                                    case 4:
                                        old_subtotal = 0.15 * (day - 3) * employeePrice;
                                        sum_variantsRent_ = sum_variantsRent_ + old_subtotal;
                                        break;
                                    case 5:
                                        sum_variantsRent_ += old_subtotal;
                                        break;
                                    case 6:
                                        sum_variantsRent_ += old_subtotal;
                                        break;
                                    case 7:
                                        old_subtotal = 0.1 * (day - 6) * employeePrice;
                                        sum_variantsRent_ = sum_variantsRent_ + old_subtotal;
                                        break;
                                    case 8:
                                        sum_variantsRent_ += old_subtotal;
                                        break;
                                    case 9:
                                        sum_variantsRent_ += old_subtotal;
                                        break;
                                    case 10:
                                        sum_variantsRent_ += old_subtotal;
                                        break;
                                    case 11:
                                        old_subtotal = 0.05 * (day - 10) * employeePrice;
                                        sum_variantsRent_ += old_subtotal;
                                        break;
                                    case 12:
                                    case 13:
                                    case 14:
                                    case 15:
                                    case 16:
                                    case 17:
                                    case 18:
                                    case 19:
                                    case 20:
                                    case 21:
                                    case 22:
                                    case 23:
                                    case 24:
                                    case 25:
                                    case 26:
                                    case 27:
                                    case 28:
                                    case 29:
                                    case 30:
                                        sum_variantsRent_ += old_subtotal;
                                        break;
                                    default:
                                        sum_variantsRent_ += old_subtotal;
                                        break;
                                }


                            } else {

                                switch (day) {
                                    case 1:
                                    case 2:
                                    case 3:
                                        sum_variantsRent_ = Number($(this).val());
                                        break;
                                    case 4:
                                        old_subtotal = 0.15 * (day - 3) * Number($(this).val());
//                                        console.log(old_subtotal);
                                        sum_variantsRent_ = sum_variantsRent_ + old_subtotal;
//                                        console.log(sum_variantsRent_);
                                        break;
                                    case 5:
                                        sum_variantsRent_ += old_subtotal;
                                        break;
                                    case 6:
                                        sum_variantsRent_ += old_subtotal;
                                        break;
                                    case 7:
                                        old_subtotal = 0.1 * (day - 6) * Number($(this).val());
                                        sum_variantsRent_ = sum_variantsRent_ + old_subtotal;
                                        break;
                                    case 8:
                                        sum_variantsRent_ += old_subtotal;
                                        break;
                                    case 9:
                                        sum_variantsRent_ += old_subtotal;
                                        break;
                                    case 10:
                                        sum_variantsRent_ += old_subtotal;
                                        break;
                                    case 11:
                                        old_subtotal = 0.05 * (day - 10) * Number($(this).val());
                                        sum_variantsRent_ += old_subtotal;
                                        break;
                                    case 12:
                                    case 13:
                                    case 14:
                                    case 15:
                                    case 16:
                                    case 17:
                                    case 18:
                                    case 19:
                                    case 20:
                                    case 21:
                                    case 22:
                                    case 23:
                                    case 24:
                                    case 25:
                                    case 26:
                                    case 27:
                                    case 28:
                                    case 29:
                                    case 30:
                                        sum_variantsRent_ += old_subtotal;
                                        break;
                                    default:
                                        sum_variantsRent_ += old_subtotal;
                                        break;
                                }

                            }
//                        }
                        }
                        sum_variantsRent +=sum_variantsRent_;
                    }
                    if (orderForEmployee) {
                        if (itemIsAccessory == 'false') {
                            sum_variantsRent += 295;
                            // sum_variants += 100;
                            // химчистка
                            // sum_variantsRent += 200;
                        } else {
                            sum_variantsRent += 55;
                        }
                    }
                }
                sum_variants = sum_variantsRent + sum_variantsSale;

                if (parseInt($(this).closest('.row').find('.cash_bonus').val()) == 1) {
                    cash_bonus_present = true;
                }

            });

            if (cash_bonus_present) {
                $('.cash-bonus-note').removeClass('no-display');
            } else {
                $('.cash-bonus-note').addClass('no-display');
            }

            var coupon = Number($('input[name="coupon_discount"]').val());
            //Total bonuses
            if (coupon > sum_variants) {
                coupon = sum_variants;
            }
            if (coupon > totalBonuses && parseInt($('input[name=user_id]').val()) !== 20446) { // Зайчук телефон 9.02.2018  приблизно 17:00
                coupon = totalBonuses;
            } else if (coupon > totalBonuses && parseInt($('input[name=user_id]').val()) === 20446) {  // Зайчук телефон 9.02.2018  приблизно 17:00

                if ((coupon - parseInt(totalBonuses)) > 5000 && coupon !== 0) {
                    alert('Можно ввести не больше -5000');
                    coupon = (parseInt(totalBonuses) + 5000);
                }
            }

            if (coupon < 0 && parseInt($('input[name=user_id]').val()) !== 20446) { // Зайчук телефон 9.02.2018  приблизно 17:00
                coupon = 0;
            }
            cupon = coupon;

            if ($('input[name="id"]').val() == "") {
                if ($('input[name="discount"]').val() == "") {
                    discount = 0;
                    sum_with_discount += sum_variants;
                } else {
                    discount = Number($('input[name="discount"]').val());
                    sum_with_discount += sum_variants - (sum_variants * discount) / 100;
                }

                if ($('input[name="coupon_discount"]').val() == "") {
                    cupon = 0;
                    sum_with_coupon_discount += sum_with_discount;
                } else {
                    sum_with_coupon_discount += sum_with_discount - cupon;
                }

                if ($('input[name="delivery_price"]').val() == "") {
                    delivery = 0;
                } else {
                    delivery = Number($('input[name="delivery_price"]').val());
                }

                if ($('#separate_delivery').attr("checked")) {
                    sum_with_delivery = sum_with_coupon_discount;
                } else {
                    var freeFrom = parseFloat($('select[name="delivery_id"]').find('option:selected').data('free-from'));
                    if (!isNaN(freeFrom) && freeFrom > 0.0 && sum_with_coupon_discount > freeFrom) {
                        delivery = 0;
                    }
                    sum_with_delivery = sum_with_coupon_discount + delivery;
                }

                var order_city_id = parseInt($(document).find('input.order_city_id').val());
                if (!isNaN(order_city_id) && order_city_id > 0) { //&& $('select[name=status]').val() == 5
                    var delivery_cities = {};
                    $(document).find('#purchases #list .row select[name*=purchases][name*=variant_id]').each(function () {
                        var city_id = $(this).find('option:selected').attr('city_id');
                        if (city_id != undefined || city_id != null) {
                            if (city_id != order_city_id) {
                                if (city_id in delivery_cities) {
                                    delivery_cities[city_id].count += 1;
                                    delivery_cities[city_id].price = Math.ceil(delivery_cities[city_id].count / 3) * 300;
                                } else {
                                    var city = {};
                                    city.id = city_id;
                                    city.name = cityName(city.id);
                                    city.count = 1;
                                    city.price = 300;
                                    delivery_cities[city_id] = city;
                                }
                            }
                        }
                    });

                    var div_delivery_from_another_cities = $(document).find('div.deliveryFromAnotherCities .delivery-from-cities-details');
                    var span_currency = div_delivery_from_another_cities.find('span.currency:first').clone();
                    var delivery_from_another_cities_total = $(document).find('.delivery-from-another-cities-total .value-input');
                    div_delivery_from_another_cities.html('');
                    if (Object.keys(delivery_cities).length > 0) {
                        $.each(delivery_cities, function (index, value) {
                            delivery_from_another_cities += value.price;
                            div_delivery_from_another_cities.append('<div class="delivery-from-another-city"></div>');
                            div_delivery_from_another_cities.find('.delivery-from-another-city:last-child').append('<span class="name">Доставка из ' + value.name + '</span>');
                            div_delivery_from_another_cities.find('.delivery-from-another-city:last-child').append('<input disabled="" type="text" value="' + value.price + '" class="text-field delivery_from_another_cities">');
                            div_delivery_from_another_cities.find('.delivery-from-another-city:last-child').append(span_currency.clone());
                        });
                    }
                    delivery_from_another_cities_total.val(number_format(delivery_from_another_cities, 2));
                }
                sum_total = sum_with_delivery + delivery_from_another_cities;
//                console.log('total price ' + sum_total);
            } else {
                if ($('input[name="discount"]').val() == "") {
                    discount = 0;
                    sum_with_discount += sum_variants;
                } else {
                    discount = Number($('input[name="discount"]').val());
                    sum_with_discount += sum_variants - (sum_variants * discount) / 100;
                }

                if ($('input[name="coupon_discount"]').val() == "") {
                    cupon = 0;
                    sum_with_coupon_discount += sum_with_discount;
                } else {
                    sum_with_coupon_discount += sum_with_discount - cupon;
                }

                if ($('input[name="delivery_price"]').val() == "") {
                    delivery = 0;
                } else {
                    delivery = Number($('input[name="delivery_price"]').val());
                }

                if ($('#separate_delivery').attr("checked")) {
                    sum_with_delivery = sum_with_coupon_discount + delivery_from_another_cities;
                } else {
                    var freeFrom = parseFloat($('select[name="delivery_id"]').find('option:selected').data('free-from'));
                    if (!isNaN(freeFrom) && freeFrom > 0.0 && sum_with_coupon_discount > freeFrom) {
                        delivery = 0;
                    }
                    sum_with_delivery = sum_with_coupon_discount + delivery;
                }
                delivery_from_another_cities = parseFloat($('.delivery-from-another-cities-total .value-input').val());
                sum_total = sum_with_delivery + delivery_from_another_cities;
//                console.log('total price_ ' + sum_total);
            }


            if ($("#sertificateValue").val() != '') {
                if (parseInt($("#sertificateUnits").val()) == 1) {
                    certificate += parseInt($("#sertificateValue").val());
                } else {
                    certificate = (sum_variants / 100) * parseFloat($("#sertificateValue").val());
                }
                sum_with_certificate = Math.max(0, (sum_with_coupon_discount - certificate));
            } else {
                sum_with_certificate = sum_with_coupon_discount;
            }

            var insuranceVal = +$('#insurance_val').val();

            sum_total = Math.max(0, (sum_total - certificate));
            sum_with_delivery = Math.max(0, (sum_with_delivery - certificate));
            $('.prepayment-tip').html('(50%<span class="insurance-tip">' + (insuranceVal.toFixed(2) ? ' + ' + insuranceVal.toFixed(2) : '') + '</span> = ' + (sum_with_delivery / 2 + insuranceVal).toFixed(2) + ' {/literal}{$currency->sign}{literal})');

            // Price correction:
            sum_total += priceCorrection;
//            console.log('total price-sert ' + sum_total);

            //////////////////////////////////// insurance
            if ($('input[name="insurance_check"]').is(':checked')) {
                insur_val = parseFloat(sum_variantsRent) * calculateInsurancePercent() / 100;
                if (!isNaN(insur_val)) {
                    sum_total = sum_total + insur_val;
                    sum_total = sum_total.toFixed(2);
                    $('#sum_total b').text(' ' + sum_total + currency);
                    $('#sum_total').data('value', sum_total);
                }
            } else {
                insur_val = 0;
            }
            $('#insurance_val').val(insur_val.toFixed(2));

            var  prepayment = $('#prepayment').val();
            var sum_with_prepayment = sum_total;
            if ($('#prepayment').val() != '') {
                sum_with_prepayment -= prepayment;//$('#prepayment').val();
            }
//            console.log(sum_with_prepayment);

            $("#insurance_check").change(function () {
                if ($('input[name="insurance_check"]').is(':checked')) {
                    insur_val = parseFloat(sum_variants - sum_variantsSale) * calculateInsurancePercent() / 100;
                    if (!isNaN(insur_val)) {
                        sum_total += insur_val;
                        $('#sum_total b').text(' ' + sum_total + currency);
                        $('#sum_total').data('value', sum_total);
                        sum_with_prepayment = sum_total;
                        if ($('#prepayment').val() != '') {
                            sum_with_prepayment -= $('#prepayment').val()
                            $('#sum_with_prepayment b').text(' ' + sum_with_prepayment + currency);
                            $('#sum_with_prepayment').data('value', sum_with_prepayment);
                        }
                    }
                } else {
                    insur_val = 0;
                    insur_val_chan = parseFloat(sum_variants - sum_variantsSale) * calculateInsurancePercent() / 100
                    sum_total = sum_total - insur_val_chan;
                    $('#sum_total b').text(' ' + sum_total + currency);
                    $('#sum_total').data('value', sum_total);
                    sum_with_prepayment = sum_total;
                    if ($('#prepayment').val() != '') {
                        sum_with_prepayment -= $('#prepayment').val()
                    }
                    $('#sum_with_prepayment b').text(' ' + sum_with_prepayment + currency);
                    $('#sum_with_prepayment').data('value', sum_with_prepayment);
                }

                $('#insurance_val').val(insur_val).change();
            });

            var insurance_value = parseFloat($('#insurance_val').val()) || 0;

            /** Global Loyalty Program integration */
            (function () {
                var loyaltyTotalBalance = parseFloat($('#totalLoyaltyBonuses').val()) || 0;
                var $loyaltyBonuses = $('input[name="coupon_loyalty_discount"]');
                var loyaltyBonuses = parseFloat($loyaltyBonuses.val()) || 0;
                var photo_day = $('#for-photo-day').is(':checked');
                var for_employee = $('#for-employee').is(':checked');
                var for_partner = $('#for-partner').is(':checked');
                var $errors = $('#loyalty-errors');

                $errors.hide();

                if (
                    !loyaltyTotalBalance ||
                    !loyaltyBonuses ||
                    photo_day ||
                    for_employee ||
                    for_partner
                ) {
                    if (loyaltyBonuses) {
                        $errors.show();
                    }
                    $loyaltyBonuses.val(0);
                    return;
                }

                var withdraw = Math.max(0, Math.min(loyaltyBonuses, loyaltyTotalBalance, (sum_total - insurance_value) * 0.5));

                $loyaltyBonuses.val(withdraw);

//                if($('.order-id').val() == 49973){
//                    console.log(49973);
//                    sum_total = sum_total-100;
//                    sum_with_prepayment = sum_with_prepayment-100;
//                } else {
//                    console.log('no');
                    sum_total -= withdraw;
                    sum_with_prepayment -= withdraw;
//                }

            })();


            /** / Global Loyalty Program integration */

            $('input[name="coupon_discount"]').val(coupon);
            $('#sum_variants b').text(' ' + sum_variants.toFixed(2) + currency);
            $('#sum_with_discount b').text(' ' + sum_with_discount + currency);
            $('#sum_with_coupon_discount b').text(' ' + sum_with_coupon_discount + currency);
            $('#sum_with_delivery b').text(' ' + sum_with_delivery + currency);
            $('#sum_with_prepayment b').text(' ' + (sum_with_prepayment.toFixed(2)) + currency);
            $('#sum_with_prepayment').data('value', sum_with_prepayment);
            $('#sum_total b').text(' ' + sum_total + currency);
            $('#sum_total').data('value', sum_total);
            $('#sum_with_certificate b').text(' ' + sum_with_certificate + currency);


            return false;
        }

        $('input[name="for_photoday"], input[name="for_employee"], input[name="for_partner"]').click(function () {
            recalculate();
        });

        $('.edit_purchase input').change(function () {
            recalculate();
        });

        $('input[name="discount"]').change(function () {
            recalculate();
        });

        $('input[name="coupon_discount"]').change(function () {
            recalculate();
        });

        $('input[name="for_employee"]').change(function () {
            recalculate();
        });

        $('input[name="coupon_loyalty_discount"]').change(function () {
            recalculate();
        });

        $('input[name="delivery_price"]').change(function () {
            recalculate();
        });

        $('#separate_delivery').change(function () {
            recalculate();
        });

        function cityName(city_id) {
            switch (parseInt(city_id)) {
                case 1:
                    return "Киева";
                    break;
                case 2:
                    return "Одессы";
                    break;
                case 3:
                    return "Днепра";
                    break;
                case 4:
                    return "Харькова";
                    break;
                default:
                    return false;
            }
        };

        // Изменение цены и макс количества при изменении варианта
        function change_variant(element) {
            var size = element.find('option:selected').attr('size');
            var cash_bonus = element.find('option:selected').attr('cash_bonus');
            var size_text = '';
            switch (size) {
            {/literal}
            {foreach from=$sizes_active item=size_active}
                case '{$size_active->id}':
                    size_text = "{$size_active->size}";
                    break;
            {/foreach}
            {literal}
                default:
                    size_text = "Не указан";
                    break;
            }
            var cash_bonus_input = element.closest('.row').find('.cash_bonus');
            cash_bonus_input.val(cash_bonus);
            var rent = element.closest('.row').find('select[name*=purchases][name*=rent]').val();
            if (rent == '0') {
                price = element.find('option:selected').attr('compare_price');
            } else {
                price = element.find('option:selected').attr('price');
            }

            sellers_price = element.find('option:selected').attr('sellers_price');
            amount = element.find('option:selected').attr('amount');
            element.closest('.row').find('span.sellersPriceText').html("<br >" + number_format(sellers_price, 0, '', ''));
            element.closest('.row').find('input[name*=purchases][name*=price]').val(number_format(price, 0, '', ''));
            element.closest('.row').find('input[name*=purchases][name*=price]').attr('data-is_accessory', element.find('option:selected').attr('data-is_accessory'));
            element.closest('.row').find('input[name*=purchases][name*=price]').attr('data-owner_id', element.find('option:selected').attr('data-owner_id'));
            element.closest('.row').find('input[name*=purchases][name*=price]').attr('data-owner_bonus_percent', element.find('option:selected').attr('data-owner_bonus_percent'));
            var notForSale = parseInt(element.find('option:selected').attr('not_for_sale'));
            var sel_op = element.closest('.row').find('select[name*=purchases][name*=size]');
            $(sel_op).html("<option value='" + size + "'>" + size_text + "</option>");
            amount_select = element.closest('.row').find('select[name*=purchases][name*=amount]');
            var rent_duration = 31;
//            var default_duration = 3;//2;
//488_21
            if($('input[name*=for_photoday]').closest('.checkbox-wrapper').hasClass('checked')){
                var default_duration = 1;
            } else {
                var default_duration = 3;
            }
            if (rent == '1') {
                amount_select.find('option').each(function () {
                    $(this).remove();
                });
                for (var i = 1; i < rent_duration; i++) {
                    amount_select.append("<option value='" + i + "' " + ((i == default_duration ? 'selected' : '')) + ">" + i + " дн.</option>");
                }
            } else {
                selected_amount = amount_select.val();
                amount_select.html('');
                for (i = 1; i <= amount; i++) {
                    amount_select.append("<option value='" + i + "'>" + i + " {/literal}{$settings->units}{literal}</option>");
                }
                amount_select.val(Math.min(selected_amount, amount));
                if (!isNaN(notForSale) && notForSale == 1) {
                    alert('Для товара выставлен статус "Не на продажу"');
                }
            }
            amount_select.data('lastValue', amount_select.val());
            recalculate();
            var isRent = element.closest(".row").find('.is-rent').val();
            validateForReserved(element, function (isReserved) {

            });
            return false;
        }

        // Изменение цены и макс количества при изменении варианта
        function change_variant_size(element) {
            size = element.val();

            var var_op = element.closest('.row').find('select[name*=purchases][name*=variant_id] option');
            var product_variant;
            var_op.each(function () {
                if (size == $(this).attr('size')) {
                    $(this).selected();
                    product_variant = $(this);
                }
            });

            var rent = element.closest('.row').find('select[name*=purchases][name*=rent]').val();
            if (rent == '0') {
                price = element.closest('.row').find('select[name*=purchases][name*=variant_id] option:selected').attr('compare_price');
            } else {
                price = element.closest('.row').find('select[name*=purchases][name*=variant_id] option:selected').attr('price');
            }

            amount = product_variant.attr('amount');
            element.closest('.row').find('input[name*=purchases][name*=price]').val(price);

            //
            amount_select = element.closest('.row').find('select[name*=purchases][name*=amount]');
            selected_amount = amount_select.val();
            amount_select.html('');
            for (i = 1; i <= amount; i++) {
                amount_select.append("<option value='" + i + "'>" + i + " {/literal}{$settings->units}{literal}</option>");
            }
            amount_select.val(Math.min(selected_amount, amount));
            recalculate();

            return false;
        }

        // Редактировать покупки
        $("a.edit_purchases").click(function () {
            $(".purchases span.view_purchase").hide();
            $(".purchases span.edit_purchase").show();
            $(".edit_purchases").hide();
            $("div#add_purchase").show();
            $("div#add_purchase_by_barcode").show();
            return false;
        });

        // Редактировать получателя
        $("div#order_details a.edit_order_details").click(function () {
            $("ul.order_details .view_order_detail").hide();
            $("ul.order_details .edit_order_detail").show();
            return false;
        });

        // Редактировать примечание
        $("div#order_details a.edit_note").click(function () {
            $("div.view_note").hide();
            $("div.edit_note").show();
            return false;
        });

        // Редактировать пользователя
        $("div#order_details a.edit_user").click(function () {
            $("div.view_user").hide();
            $("#cart_number_search_block").show();
            $("#phone_search_block").show();
            $("div.edit_user").show();

            return false;
        });


        // Поле для ввода номера карты при добавления пользователя:
        var cartNumberSearchInput = $("#cart_number_search_input1");

        // Добавление пользователя по номеру телефона:
        $("#inputSearchUserByPhone").autocomplete({
            serviceUrl: 'ajax/search.php',
            minChars: 0,
            noCache: false,
            deferRequestBy: 300,
            params: {'action': 'getUserByPhone'},
            onSelect:
                function (value, data) {
                    cartNumberSearchInput.val(data.cart_number);
                    $('input#user').val(data.name + " (" + data.email + ")");
                    $('input[name="user_id"]').val(data.id).change();
                    var userSubGroupName = data.sub_group_name;
                    if (userSubGroupName != undefined && userSubGroupName != null && userSubGroupName.length > 0) {
                        $('.user-add-info .user-sub-group').text(userSubGroupName);
                        $('.user-add-info').show();
                    } else {
                        $('.user-add-info .user-sub-group').text('');
                        $('.user-add-info').hide();
                    }
                    if ($('input[name="user_id"]').val().length > 0) {
                        $.ajax({
                            url: 'ajax/bonuses_ajax.php',
                            type: 'POST',
                            dataType: 'json',
                            data: {'action': 'getUserBonuses', 'uID': data.id},
                            success: function (response) {
                                $('#totalBonusesBlock').html(" (всего есть " + response + ")");
                                $('#totalBonuses').val(response);
                                $('input[name="coupon_discount"]').prop('disabled', false);
                                $('input[name="coupon_discount"]').val('0');

                            },
                            error: function (response) {
                            },
                        });
                        //подписка добавление по юзеру
                        $.ajax({
                            url: 'ajax/subscriptions_ajax.php',
                            type: 'POST',
                            dataType: 'json',
                            data: {'action': 'getUserSubscription', 'uID': data.id, },
                            success: function (response) {
                                console.log(response);
                                var subscriptionId = $('#subscriptionId').val();
                                console.log(subscriptionId);
                                if(response.length>0) {
                                    var html = '<h2 class="no-float">Подписка</h2>' +
                                            '<div class="clearfix">' +
                                            '<div class="select-wrapper gray">' +
                                            '<div class="select-inner">' +
                                            '<select name="subscription_id" class="order-subscription">' +
                                            '<option value="">Выберите подписку</option>';

                                    for (var i in response) {
                                        // if (subscriptionId == response[i].id){
                                        //     html += '<option selected value="' + response[i].id + '">' + response[i].name + '</option>';
                                        // } else {
                                            html += '<option value="' + response[i].id + '">' + response[i].name + '</option>';
                                        // }
                                    }

                                    html += '</select>' +
                                            '</div>' +
                                            '</div>' +
                                            '</div>';
                                    console.log(html);
                                    $('.subscription_view').html(html);
                                } else {
                                    $('.subscription_view').html('');
                                }

                                //добавление подписки и сразу проверка на незавренные заказы по ней
                                $('.order-subscription').change(function () {
                                    console.log("subscription_id");
                                    $.ajax({
                                        url: 'ajax/subscriptions_ajax.php',
                                        type: 'post',
                                        dataType: 'json',
                                        data: {action: 'CheckOrderWithSubscriptionId', uid: $('input[name="user_id"]').val(), subscriptionId:$('select[name="subscription_id"]').val()},
                                        success: function (response) {
                                            if (response) {
                                                console.log(response);
                                                if(response.length>0){
                                                    for (var i in response) {
                                                        alert('У Вас есть незавершенный заказ №'+response[i].id+' с подпиской.');
                                                    }
                                                }
                                            }
                                        }
                                    });
                                    /////////////////////////////////////////////////////////////////////////////////////
                                    // TODO также закреплен ли этот товар за данной подпиской

                                    //проверка на количество предметов в заказе соответсвует ли оно разрешенному количству в подписке
                                    $.ajax({
                                        url: 'ajax/subscriptions_ajax.php',
                                        type: 'post',
                                        dataType: 'json',
                                        data: {action: 'CheckProductWithSubscriptionId', uid: $('input[name="user_id"]').val(), subscriptionId:$('select[name="subscription_id"]').val()},
                                        success: function (response) {
                                            if (response) {
                                                console.log(response);
                                                var k=0;
                                                $.each($('.purchases').find('.row'), function (key, row) {
                                                    k++
                                                });

                                                var count=0;
                                                for (var i in response) {
                                                    count =response[i].products;
                                                    console.log('count'+count);
                                                    console.log(k);
                                                    if(k>count){
                                                        $("input[name*=subscription_count_products]").val(response[i].id);
                                                        alert('Количество выбранных Вами товаров не совпадает с разрешенным для данной подписки.');
                                                    } else {
                                                        $("input[name*=subscription_count_products]").val('');
                                                    }
                                                }
                                            }
                                        }
                                    });
                                    /////////////////////////////////////////////////////////////////////////////////////
                                    return false;
                                });
                            },
                            error: function (response) {

                            },
                        });
                    }
                },
        });

        // Добавление пользователя:
        $("input#user").autocomplete({
            serviceUrl: 'ajax/search_users.php',
            minChars: 0,
            noCache: false,
            onSelect:
                function (value, data) {
                    $('input[name="user_id"]').val(data.id).change();
                    cartNumberSearchInput.val(data.cart_number);
                    var userSubGroupName = data.sub_group_name;
                    if (userSubGroupName != undefined && userSubGroupName != null && userSubGroupName.length > 0) {
                        $('.user-add-info .user-sub-group').text(userSubGroupName);
                        $('.user-add-info').show();
                    } else {
                        $('.user-add-info .user-sub-group').text('');
                        $('.user-add-info').hide();
                    }

                    if ($('input[name="user_id"]').val().length > 0) {
                        $.ajax({
                            url: 'ajax/bonuses_ajax.php',
                            type: 'POST',
                            dataType: 'json',
                            data: {'action': 'getUserBonuses', 'uID': data.id},
                            success: function (response) {
                                $('#totalBonusesBlock').html(" (всего есть " + response + ")");
                                $('#totalBonuses').val(response);
                                $('input[name="coupon_discount"]').prop('disabled', false);
                                $('input[name="coupon_discount"]').val('0');
                            },
                            error: function (response) {

                            },
                        });
                        //подписка добавление по юзеру
                        $.ajax({
                            url: 'ajax/subscriptions_ajax.php',
                            type: 'POST',
                            dataType: 'json',
                            data: {'action': 'getUserSubscription', 'uID': data.id},
                            success: function (response) {
                                console.log(response);
                                if(response.length>0) {
                                    var html = '<h2 class="no-float">Подписка</h2>' +
                                            '<div class="clearfix">' +
                                            '<div class="select-wrapper gray">' +
                                            '<div class="select-inner">' +
                                            '<select name="subscription_id" class="order-subscription">' +
                                            '<option value="">Выберите подписку</option>';

                                    for (var i in response) {
                                        html += '<option value="' + response[i].id + '">' + response[i].name + '</option>';
                                    }

                                    html += '</select>' +
                                            '</div>' +
                                            '</div>' +
                                            '</div>';
                                    console.log(html);
                                    $('.subscription_view').html(html);
                                } else {
                                    $('.subscription_view').html('');
                                }

                                //добавление подписки и сразу проверка на незавренные заказы по ней
                                $('.order-subscription').change(function () {
                                    console.log("subscription_id");
                                    $.ajax({
                                        url: 'ajax/subscriptions_ajax.php',
                                        type: 'post',
                                        dataType: 'json',
                                        data: {action: 'CheckOrderWithSubscriptionId', uid: $('input[name="user_id"]').val(), subscriptionId:$('select[name="subscription_id"]').val()},
                                        success: function (response) {
                                            if (response) {
//                                                console.log(response);
                                                if(response.length>0){
                                                    for (var i in response) {
                                                        if(response[i].id !==$('.order-id').val()) {
                                                            alert('У Вас есть незавершенный заказ №'+response[i].id+' с подпиской.');
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    });

                                    /////////////////////////////////////////////////////////////////////////////////////
                                    // TODO также закреплен ли этот товар за данной подпиской

                                    //проверка на количество предметов в заказе соответсвует ли оно разрешенному количству в подписке
                                    $.ajax({
                                        url: 'ajax/subscriptions_ajax.php',
                                        type: 'post',
                                        dataType: 'json',
                                        data: {action: 'CheckProductWithSubscriptionId', uid: $('input[name="user_id"]').val(), subscriptionId:$('select[name="subscription_id"]').val()},
                                        success: function (response) {
                                            if (response) {
                                                console.log(response);
                                                var k=0;
                                                $.each($('.purchases').find('.row'), function (key, row) {
                                                    k++
                                                });

                                                var count=0;
                                                for (var i in response) {
                                                    count =response[i].products;
                                                    console.log('count'+count);
                                                    console.log(k);
                                                    if(k>count){
                                                        $("input[name*=subscription_count_products]").val(response[i].id);
                                                        alert('Количество выбранных Вами товаров не совпадает с разрешенным для данной подписки.');
                                                    } else {
                                                        $("input[name*=subscription_count_products]").val('');
                                                    }
                                                }
                                            }
                                        }
                                    });
                                    /////////////////////////////////////////////////////////////////////////////////////

                                    return false;
                                });
                            },
                            error: function (response) {

                            },
                        });
                    }
                },
        });



        // Удалить пользователя
        $("div#order_details a.delete_user").click(function () {
            $('input[name="user_id"]').val(0).change();
            $('div.view_user').hide();
            $('div.edit_user').hide();
            $('.user-add-info .user-sub-group').text('');
            $('.user-add-info').hide();
            return false;
        });

        // Посмотреть адрес на карте
        $("a#address_link").attr('href', 'http://maps.yandex.ru/?text=' + $('#order_details textarea[name="address"]').val());

        // Подтверждение удаления
        $('select[name*=purchases][name*=variant_id]').bind('change', function () {
            change_variant($(this));
        });
        $('select[name*=purchases][name*=size_id]').bind('change', function () {
            change_variant_size($(this));
        });
        $("input[name='status_deleted']").click(function () {
            if (!confirm('Подтвердите удаление')) {
                return false;
            }
        });

        // Добавление пользователя по номеру карты:
        var autocompleteCartNumber = cartNumberSearchInput.autocomplete({
            serviceUrl: 'ajax/autocomplite.php',
            minChars: 0,
            noCache: false,
            deferRequestBy: 300,
            params: {action: 'autocompliteUserByCart'},
            onSelect:
                function (value, data) {
                    cartNumberSearchInput.val(data.cart_number);
                    $('input#user').val(data.name + " (" + data.email + ")");
                    $('input[name="user_id"]').val(data.id).change();
                    var userSubGroupName = data.sub_group_name;
                    if (userSubGroupName != undefined && userSubGroupName != null && userSubGroupName.length > 0) {
                        $('.user-add-info .user-sub-group').text(userSubGroupName);
                        $('.user-add-info').show();
                    } else {
                        $('.user-add-info .user-sub-group').text('');
                        $('.user-add-info').hide();
                    }
                    if ($('input[name="user_id"]').val().length > 0) {
                        $.ajax({
                            url: 'ajax/bonuses_ajax.php',
                            type: 'POST',
                            dataType: 'json',
                            data: {'action': 'getUserBonuses', 'uID': data.id},
                            success: function (response) {
                                $('#totalBonusesBlock').html(" (всего есть " + response + ")");
                                $('#totalBonuses').val(response);
                                $('input[name="coupon_discount"]').prop('disabled', false);
                                $('input[name="coupon_discount"]').val('0');
                            },
                            error: function (response) {

                            },
                        });
                    }
                },
        }).enable();

        // Добавление пользователя по номеру карты:
        cartNumberSearchInput.keypress(function (evt) {
            if (evt.keyCode == 13) {
                var card = cartNumberSearchInput.val();
                $.ajax({
                    type: 'POST',
                    dataType: 'json',
                    url: 'ajax/get_user_by_card.php',
                    data: {'action': 'getUserByCardNumber', 'card': card},
                    success: function (data) {
                        cartNumberSearchInput.val(data.cart_number);
                        $('input#user').val(data.name + " (" + data.email + ")");
                        $('input[name="user_id"]').val(data.id).change();
                        if ($('input[name="user_id"]').val().length > 0) {
                            $.ajax({
                                url: 'ajax/bonuses_ajax.php',
                                type: 'POST',
                                dataType: 'json',
                                data: {'action': 'getUserBonuses', 'uID': data.id},
                                success: function (response) {
                                    $('#totalBonusesBlock').html(" (всего есть " + response + ")");
                                    $('#totalBonuses').val(response);
                                    $('input[name="coupon_discount"]').prop('disabled', false);
                                    $('input[name="coupon_discount"]').val('0');
                                },
                                error: function (response) {

                                },
                            });
                            //подписка добавление по юзеру
                            $.ajax({
                                url: 'ajax/subscriptions_ajax.php',
                                type: 'POST',
                                dataType: 'json',
                                data: {'action': 'getUserSubscription', 'uID': data.id},
                                success: function (response) {
                                    console.log(response);
                                    if(response.length>0) {
                                        var html = '<h2 class="no-float">Подписка</h2>' +
                                                '<div class="clearfix">' +
                                                '<div class="select-wrapper gray">' +
                                                '<div class="select-inner">' +
                                                '<select name="subscription_id" class="order-subscription">' +
                                                '<option value="">Выберите подписку</option>';

                                        for (var i in response) {
                                            html += '<option value="' + response[i].id + '">' + response[i].name + '</option>';
                                        }

                                        html += '</select>' +
                                                '</div>' +
                                                '</div>' +
                                                '</div>';
                                        console.log(html);
                                        $('.subscription_view').html(html);
                                    } else {
                                        $('.subscription_view').html('');
                                    }

                                    //добавление подписки и сразу проверка на незавренные заказы по ней
                                    $('.order-subscription').change(function () {
                                        console.log("subscription_id");
                                        $.ajax({
                                            url: 'ajax/subscriptions_ajax.php',
                                            type: 'post',
                                            dataType: 'json',
                                            data: {action: 'CheckOrderWithSubscriptionId', uid: $('input[name="user_id"]').val(), subscriptionId:$('select[name="subscription_id"]').val()},
                                            success: function (response) {
                                                if (response) {
                                                    console.log(response);
                                                    if(response.length>0){
                                                        for (var i in response) {
                                                            alert('У Вас есть незавершенный заказ №'+response[i].id+' с подпиской.');
                                                        }
                                                    }
                                                }
                                            }
                                        });
                                        /////////////////////////////////////////////////////////////////////////////////////
                                        // TODO также закреплен ли этот товар за данной подпиской

                                        //проверка на количество предметов в заказе соответсвует ли оно разрешенному количству в подписке
                                        $.ajax({
                                            url: 'ajax/subscriptions_ajax.php',
                                            type: 'post',
                                            dataType: 'json',
                                            data: {action: 'CheckProductWithSubscriptionId', uid: $('input[name="user_id"]').val(), subscriptionId:$('select[name="subscription_id"]').val()},
                                            success: function (response) {
                                                if (response) {
                                                    console.log(response);
                                                    var k=0;
                                                    $.each($('.purchases').find('.row'), function (key, row) {
                                                        k++
                                                    });

                                                    var count=0;
                                                    for (var i in response) {
                                                        count =response[i].products;
                                                        console.log('count'+count);
                                                        console.log(k);
                                                        if(k>count){
                                                            $("input[name*=subscription_count_products]").val(response[i].id);
                                                            alert('Количество выбранных Вами товаров не совпадает с разрешенным для данной подписки.');
                                                        } else {
                                                            $("input[name*=subscription_count_products]").val('');
                                                        }
                                                    }
                                                }
                                            }
                                        });
                                        /////////////////////////////////////////////////////////////////////////////////////
                                        return false;
                                    });
                                },
                                error: function (response) {

                                },
                            });
                        }
                    },

                });
                evt.preventDefault();
                return;
            }

        });

        function validatePurchases() {
            $.each($(document).find('input.product_date'), function (index, element) {
                var self = $(this);
                var alt = $(this).next();
                self.data('lastValue', self.val());

                validateForReserved(self, function (isReserved) {
                    if (isReserved) {
                        if (self.data('lastValue') != undefined) {
                            self.val('');
                            alt.val('');
                            // self.val(self.data('lastValue'));
                            // alt.val(jQuery.datepicker.formatDate('yy-mm-dd', parseDate(self.data('lastValue'), 'dd.mm.yyyy')));
                        } else {
                            self.val('');
                            alt.val('');
                        }
                    } else {
                        self.data('lastValue', self.val());
                    }
                });
            });
        }

        recalculate();
        // validatePurchases();
    });

    function validate(evt) {
        var theEvent = evt || window.event;
        var key = theEvent.keyCode || theEvent.which;
        key = String.fromCharCode(key);
        var regex = /[0-9]|/;
        if (evt.ctrlKey || evt.altKey || (evt.keyCode == 13)
            || (47 < evt.keyCode && evt.keyCode < 58 && evt.shiftKey == false)
            || (95 < evt.keyCode && evt.keyCode < 106)
            || (evt.keyCode == 8) || (evt.keyCode == 9)
            || (evt.keyCode > 34 && evt.keyCode < 40)
            || (evt.keyCode == 46)
            || (evt.keyCode > 111 && evt.keyCode < 124)) {

        } else if (!regex.test(key)) {
            theEvent.returnValue = false;
            if (theEvent.preventDefault) theEvent.preventDefault();
        }
    }


    $('.outputReason').addClass('hidden');

    if (document.getElementById('rent_reason').value == 25) {
        $('.outputReason').removeClass('hidden');
    } else {
        $('.outputReason').addClass('hidden');
    }


    $('#rent_reason').change(function () {
        var reason = $(this).children('option:selected').val();
        if (reason == 25) {
            $('.outputReason').removeClass('hidden');
        } else {
            $('.outputReason').addClass('hidden');
        }
    });
    $('.outputKnow').addClass('hidden');


    if (document.getElementById('how_know').value == 25) {
        $('.outputKnow').removeClass('hidden');
    } else {
        $('.outputKnow').addClass('hidden');
    }
    $('#how_know').change(function () {
        var reason = $(this).children('option:selected').val();
        if (reason == 25) {
            $('.outputKnow').removeClass('hidden');
        } else {
            $('.outputKnow').addClass('hidden');
        }
    });

    // $('#insurance_val').change(function() {
    //     let $this = $(this);
    //     let insuranceVal = +$this.val();
    //     let $insuranceTip = $('.insurance-tip');
    //
    //     if (insuranceVal) {
    //         $insuranceTip.text(' + ' + insuranceVal);
    //     }
    //     else {
    //         $insuranceTip.empty();
    //     }
    // });
</script>

    <style>
        .ui-autocomplete {
            background-color: #ffffff;
            width: 100px;
            overflow: hidden;
            border: 1px solid #e0e0e0;
            padding: 5px;
        }

        .ui-autocomplete li.ui-menu-item {
            overflow: hidden;
            white-space: nowrap;
            display: block;
        }

        .ui-autocomplete a.ui-corner-all {
            overflow: hidden;
            white-space: nowrap;
            display: block;
        }
    </style>
{/literal}
