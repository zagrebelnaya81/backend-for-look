<?php
require_once('api/OhMyPro.php');

class OrderAdminSubscriptions extends OhMyPro
{
    public function fetch()
    {
        // Variants statuses:
        $variantsStatuses = $this->variants->getVariantsStatuses();
        $this->design->assign('variantsStatuses', $variantsStatuses);

        //Данние для истории
        $history_params = array();
        $history_params['user'] = $_SERVER['PHP_AUTH_USER'];

        $lpBonuses = null;

        $sizesActive = $this->sizesDB->getActiveSizes();
        $this->design->assign("sizes_active", $sizesActive);

        if ($this->request->method('post')) {
            $accountingRecord = array();

            $manager = $this->request->post('manager');
            if (isset($manager)) {
                $history_params['user'] = $manager;
            }
            $from_site = intval($this->request->post('from_site'));
            if (isset($from_site)) {
                $history_params['from_site'] = $from_site;
            }

            $order = new stdClass();
            $order->id = $this->request->post('id', 'integer');
            $order->name = $this->request->post('name');
            $order->email = $this->request->post('email');
            $order->phone = $this->request->post('phone');
            $order->address = $this->request->post('address');
            $order->delivery_time = $this->request->post('delivery_time');
            $order->comment = $this->request->post('comment');
            $order->details = $this->request->post('details');
            $order->note = $this->request->post('note');
            $order->price_correction = $this->request->post('price_correction', 'floatr');
            $order->price_correction_description = $this->request->post('price_correction_description');
            $order->discount = $this->request->post('discount', 'floatr');
            $order->coupon_discount = $this->request->post('coupon_discount', 'floatr');
            $order->loyalty_discount = $this->request->post('coupon_loyalty_discount', 'floatr');
            $order->delivery_id = $this->request->post('delivery_id', 'integer');
            $order->delivery_price = $this->request->post('delivery_price', 'float');
            $order->payment_method_id = $this->request->post('payment_method_id', 'integer');
            $order->paid = $this->request->post('paid', 'integer');
            $order->user_id = $this->request->post('user_id', 'integer');
            $order->separate_delivery = $this->request->post('separate_delivery', 'integer');
            $order->coupon_code = $this->request->post('sertificateCode', 'integer');
            $order->prepayment = $this->request->post('prepayment', 'floatr');
            $order->rent_reason = $this->request->post('rent_reason');
            $order->other_reason = $this->request->post('other_reason');
            $order->how_know = $this->request->post('how_know');
            $order->other_how_know = $this->request->post('other_how_know');
            $insuranceCheck = $this->request->post('insurance_check');
            if($this->request->post('insurance', 'floatr')){
                $order->insurance = $this->request->post('insurance', 'floatr');
            } else if($this->request->get('insurance', 'floatr')){
                $insuranceCheck =1;
                $order->insurance = $this->request->get('insurance', 'floatr');
            }


            if($this->request->post('subscription_id')){
                $order->subscription_id =$this->request->post('subscription_id');
            } else if ($this->request->get('subscription')){
                $order->subscription_id = $this->request->get('subscription');
            }


            // $order->service_days = $this->request->post('service-days', 'integer');
            $forPhotoDay = $this->request->post('for_photoday');
            $forEmployee = $this->request->post('for_employee');
            $forPartner = $this->request->post('for_partner');
            $forProm = $this->request->post('for_prom');
            // $hochuUa = $this->request->post('hochu_ua');
            $order->for_photoday = (isset($forPhotoDay)) ? 1 : 0;
            $order->for_employee = (isset($forEmployee)) ? 1 : 0;
            $order->for_partner = (isset($forPartner) && empty($order->for_employee)) ? 1 : 0;
            $order->for_prom = (isset($forProm)) ? 1 : 0;
            $order->insurance_check = (isset($insuranceCheck)) ? 1 : 0;
            // $order->hochu_ua = (isset($hochuUa))? 1: 0;


            $currentPayment = ceil($order->prepayment);

            if ($order->for_employee == 1) {

            }
            if ($order->for_prom == 0) {
                $order->school_city = null;
                $order->school_name = null;
            } else {
                $order->school_city = $this->request->post('school_city');
                $order->school_name = $this->request->post('school_name');
            }

            // $new_status = intval($this->request->post('status', 'integer'));
            // if($new_status != 0 && $new_status != 3 && $new_status != 5){
            //     $order->service_days = max(1, $this->orders->serviceDaysAfterRent);
            // }

            if (isset($manager)) {
                $order->manager = $manager;
                $managerCity = $this->managers->get_manager_city($manager);
            }
            if (isset($managerCity) && $managerCity > 0) {
                $order->city_id = $managerCity;
            } else {
                $order->city_id = 1;
            }

            // Детали заказа подтягиваем автоматически, если не были заполнены:
            $user = $this->users->get_user(intval($order->user_id));
            if (empty($order->name)) {
                $order->name = $user->name . ' ' . $user->last_name;
            }
            if (empty($order->email)) {
                $order->email = $user->email;
            }
            if (empty($order->phone)) {
                $order->phone = $user->phone;
            }
            if ($order->phone == null) {
                $order->phone = '';
            }

            /* loyalty check is allowed to save */
            $lpBonuses = 0;

            if (isset($order) && isset($order->id)) {
                $userID = $order->user_id;
                if ($userID) {
                    $lpBonuses = (float)$this->loyalty->getClientBonuses($user);
                    $this->design->assign('total_loyalty_bonuses', $lpBonuses);
                }
            }

            $tmpOrder = $this->orders->get_order($order->id);
            $withdrawLoyalty = max(0,
                min(
                    $order->loyalty_discount,
                    $lpBonuses,
                    ($tmpOrder->full_price /*- $order->insurance*/) * 0.5
                )
            );
            $order->loyalty_discount = $withdrawLoyalty;

            if (!$lpBonuses || $order->for_photoday || $order->for_employee || $order->for_partner) {
                $order->loyalty_discount = 0;
            }
            /* / loyalty check is allowed to save */


            //отсылка письма с опросом клиенту
            $order_status = $this->request->post('status', 'integer');

//            if ($order_status == 1) {
//                $purchasesCount = $this->getPurchasesCount($order->user_id, $order->id, '2019-06-01 00:00:00', '2019-08-31 00:00:00');
//                $messageData = $this->dressAsGiftMessageData($purchasesCount);
//
//                if ($messageData) {
//                    OhMyPro::notify()->email($user->email, $messageData->subject, $messageData->message);
//                }
//            }

            if ($order_status == 2) {
                $evaluateService = new stdClass();
                $evaluateService->name = $user->name;
                $evaluateService->email_to = $user->email;
                $evaluateService->order_id = $order->id;
                $evaluateService->user_id = $user->id;
                if (!$this->notify->sendOverallServiceQualityPoll($evaluateService)) {
                    $this->design->assign('message_error', $_SESSION['smtp_email_send_error']);
//                    $this->design->assign('smtp_message_error', $_SESSION['smtp_email_send_error']);
                    unset($_SESSION['smtp_email_send_error']);
                } else {
                    $this->design->assign('message_success_send', 'service_quality_poll_sent');
                }
            }

            if (!$order_labels = $this->request->post('order_labels')) {
                $order_labels = array();
            }
            // Покупки
            $purchases = array();
            if ($this->request->post('purchases')) {
                foreach ($this->request->post('purchases') as $n => $va) {
                    foreach ($va as $i => $v) {
                        if (!isset($purchases[$i])) {
                            $purchases[$i] = new stdClass();
                        }
                        $purchases[$i]->$n = $v;
                    }
                }
            }
            $saveResult = false;
            if (count($purchases) <= 0) {
                $this->design->assign('message_error', 'no_purchases');
            } else {
                $hasBlockedVariants = false;
                $errorInRentStartDate = false;
                $hasVariantCopies = false;
                $variantIds = array();
                $blockedInfo = array();

                foreach ($purchases as $purchase) {
                    if (!empty($purchase->variant_id) && in_array(intval($purchase->variant_id), $variantIds)) {
                        $hasVariantCopies = true;
                        $this->design->assign('message_error', 'order_has_variant_copies');
                        break;
                    }
                    $variantIds[] = intval($purchase->variant_id);
                    $orderStatus = $this->request->post('status');
                    if ($orderStatus != 3) {
                        if (intval($purchase->rent) > 0 && empty($purchase->start_date)) {
                            $errorInRentStartDate = true;
                            $this->design->assign('message_error', 'rent_start_date_error');
                            break;
                        }
                        if ($this->variants->isVariantBlockedForPeriod($purchase->variant_id, $purchase->start_date, empty($order->id) ? null : $order->id, intval($purchase->rent), intval($purchase->amount))) {
                            $blockedInfo[$purchase->variant_id] = $this->variants->getVariantBlockedForOrder($purchase->variant_id, $purchase->start_date, empty($order->id) ? null : $order->id, intval($purchase->rent), intval($purchase->amount));
                            $hasBlockedVariants = true;
                            if (intval($purchase->rent) == 1) {
                                $this->design->assign('message_error', 'has_blocked_rents');
                            } else {
                                $this->design->assign('message_error', 'has_blocked_sales');
                            }
                        }
                    }
                }

                if ($hasBlockedVariants) {
                    $this->design->assign('blockedInfo', $blockedInfo);
                }
                if (!$hasBlockedVariants && !$errorInRentStartDate && !$hasVariantCopies) {
                    if ($order->prepayment > 0 && ($this->request->post('status')) == 0) {
                        $this->design->assign('message_error', 'new_order_with_prepayment');
                    } else {
                        if (empty($order->id)) {
                            // Delivery from another cities:
                            if (($this->request->post('status')) == 5) {
                                $delivery_from_another_cities = [];
                                $variants = $this->variants->get_variants(array('id' => $variantIds));
                                foreach ($variants as $variant) {
                                    if ($variant->city_id != $order->city_id) {
                                        if (array_key_exists($variant->city_id, $delivery_from_another_cities)) {
                                            $delivery_from_another_cities[$variant->city_id]->count++;
                                            $delivery_from_another_cities[$variant->city_id]->price = ceil($delivery_from_another_cities[$variant->city_id]->count / 3) * 300;
                                        } else {
                                            $obj = new stdClass();
                                            $obj->city_id = $variant->city_id;
                                            $obj->count = 1;
                                            $obj->price = 300;
                                            $delivery_from_another_cities[$variant->city_id] = $obj;
                                        }
                                    }
                                }
                                foreach ($delivery_from_another_cities as $delivery_from_another_city) {
                                    $order->delivery_from_another_cities += $delivery_from_another_city->price;
                                }
                            }

                            $order->author = $order->manager;
                            $this->bonuses->remove_writeoffs_record($order->id);
                            $totalBonuses = $this->bonuses->get_user_bonuses_sum($order->user_id);
                            if ($totalBonuses < $order->coupon_discount) {
                                $coupon = $totalBonuses;
                            } elseif (intval($order->coupon_discount) < 0) {
                                $coupon = 0;
                            } else {
                                $coupon = $order->coupon_discount;
                            }

                            $order->id = $this->orders->add_order($order);
                            $saveResult = intval($order->id) > 0 ? true : false;
                            if ($saveResult !== false) {
                                $this->design->assign('message_success', 'added');

                                if (isset($order->user_id)) {
                                    $order->coupon_discount = max(0, $order->coupon_discount);
                                    $this->bonuses->write_off_bonuses($order->coupon_discount, $order->user_id, $order->id);
                                }

                                //Запишем изменение в историю
                                $history_params['order_id'] = $order->id;
                                $history_params['details'] = 'Добавлен новый заказ № ' . $order->id;
                                $history_id = $this->users->add_to_history($history_params, 0);
                                if (!$history_id) {
                                    $error = "";
                                }
                                //Сертификат
                                if (intval($order->coupon_code) > 0) {
                                    $orderCertificate = $this->coupons->get_coupon(intval($order->coupon_code));
                                    $orderCertificate->usages++;
                                    if (isset($orderCertificate->valid)) {
                                        unset($orderCertificate->valid);
                                    }
                                    $this->coupons->update_coupon($orderCertificate->id, $orderCertificate);
                                }
                                //Сертификат Конец.
                                // Учет
                                $accountingRecord['order_id'] = $order->id;
                                $accountingRecord['description'] = 'Заказ создан';
                                $accountingRecord['sum'] = $order->prepayment;
                                $accountingRecord['manager'] = $order->manager;
                            } else {
                                $this->design->assign('message_error', 'added');
                            }
                        } else {
                            //Сертификат
                            $oldOrder = $this->orders->get_order($order->id);
                            $oldOrder->purchases = $this->orders->get_purchases(array('order_id' => $oldOrder->id));
                            $oldStatus = intval($oldOrder->status);

                            if ($oldStatus == 3) {
                                $this->design->assign('message_error', 'update_deleted_order');
                                $saveResult = false;
                            } elseif ($oldOrder->prepayment > 0 && ($this->request->post('status')) == 0) {
                                $this->design->assign('message_error', 'new_order_with_prepayment');
                            } else {
                                $order->prepayment += floatval($oldOrder->prepayment);
                                if (intval($oldOrder->coupon_code) > 0) {
                                    $oldOrderСertificate = $this->coupons->get_coupon(intval($oldOrder->coupon_code));
                                    if ($oldOrderСertificate->usages > 0) {
                                        $oldOrderСertificate->usages--;
                                        if (isset($oldOrderСertificate->valid)) {
                                            unset($oldOrderСertificate->valid);
                                        }
                                        $this->coupons->update_coupon(intval($oldOrderСertificate->id), $oldOrderСertificate);
                                    }
                                }
                                if (intval($order->coupon_code) > 0) {
                                    $orderCertificate = $this->coupons->get_coupon(intval($order->coupon_code));
                                    $orderCertificate->usages++;
                                    if (isset($orderCertificate->valid)) {
                                        unset($orderCertificate->valid);
                                    }
                                    $this->coupons->update_coupon(intval($orderCertificate->id), $orderCertificate);
                                }
                                //Сертификат Конец.
                                $this->bonuses->remove_writeoffs_record($order->id);
                                $totalBonuses = $this->bonuses->get_user_bonuses_sum($order->user_id);

                                if ($totalBonuses < $order->coupon_discount) {
                                    $coupon = $totalBonuses;
                                } elseif ($order->coupon_discount < 0) {
                                    $coupon = 0;
                                } else {
                                    $coupon = $order->coupon_discount;
                                }

                                $saveResult = $this->orders->update_order($order->id, $order);
                                $order->delivery_from_another_cities = $oldOrder->delivery_from_another_cities;
                                if ($saveResult !== false) {
                                    $this->design->assign('message_success', 'updated');

                                    if (isset($order->user_id)) {
                                        $order->coupon_discount = max(0, $order->coupon_discount);
                                        $this->bonuses->write_off_bonuses($order->coupon_discount, $order->user_id, $order->id);
                                    }

                                    //Запишем изменение в историю
                                    $history_params['order_id'] = $order->id;
                                    $history_params['details'] = 'Заказ № ' . $order->id . ' обновлен.';

                                    // Учет:
                                    if (isset($oldOrder) && (($oldOrder->prepayment != $order->prepayment) || ($oldOrder->for_photoday != 1 && $order->for_photoday == 1))) {
                                        $accountingRecord['sum'] = floatval($order->prepayment) - $oldOrder->prepayment;
                                        $accountingRecord['order_id'] = $order->id;
                                        $accountingRecord['prev_order_status_id'] = intval($oldOrder->status_id);
                                        $accountingRecord['manager'] = $order->manager;
                                    }
                                } else {
                                    $this->design->assign('message_error', 'updated');
                                }
                            }
                        }
                    }
                    if ($order->id && $saveResult !== false) {

                        if (floor($currentPayment) > 0 && floor($order->delivery_from_another_cities) > 0) {
                            $bonusesToBeAssignedForDelivery = !empty($oldOrder) ? max(0, floor(floor($order->delivery_from_another_cities) - floor($oldOrder->prepayment))) : floor($order->delivery_from_another_cities);
                            $bonusesToBeAssignedForDelivery = floor($currentPayment) >= floor($bonusesToBeAssignedForDelivery) ? floor($bonusesToBeAssignedForDelivery) : floor($currentPayment);
                            if ($bonusesToBeAssignedForDelivery > 0) {
                                $this->bonuses->setUserAdditionalBonuses($order->user_id, min($bonusesToBeAssignedForDelivery, $order->delivery_from_another_cities), 'Заказ №' . $order->id . ', доставка из других городов', 0, '', 0);
                            }
                        }

                        $this->orders->update_order_labels($order->id, $order_labels);
                        // Принять?
                        if ($this->request->post('status_new')) {
                            $new_status = 0;
                        } elseif ($this->request->post('status_accept')) {
                            $new_status = 1;
                        } elseif ($this->request->post('status_done')) {
                            $new_status = 2;
                        } elseif ($this->request->post('status_deleted')) {
                            $new_status = 3;
                        } else {
                            $new_status = $this->request->post('status', 'string');
                        }
                        $oldPurchases = $this->orders->get_purchases(array('order_id' => $order->id));
                        $posted_purchases_ids = array();
                        $posted_variants_ids = array();
                        foreach ($purchases as $purchase) {
                            $variant = $this->variants->get_variant($purchase->variant_id);
                            if ($new_status == 2 && intval($purchase->rent) == 1 && (!isset($oldStatus) || ((isset($oldStatus) && $oldStatus != 2 && $oldStatus != 5)))) {
                                if ($order->for_photoday == 1) {
                                    $this->variants->update_photodays_count(intval($variant->id), (intval($variant->photodays_count) + 1));
                                } else {
                                    $new_rent_num = intval($variant->rent_num) + 1;
                                    $this->variants->update_rent_num(intval($variant->id), $new_rent_num);
                                }
                                $usages = intval($variant->photodays_count) + intval($variant->rent_num) + 1;

                                //************ Оповещаем байера *************************************
                                $this->notify->bayerNotify(intval($variant->id), $usages);
                                //*******************************************************************

                                if ($usages >= 3) {
                                    $user = $this->users->getDressesUser(intval($variant->sku));
                                    if (intval($variant->purchase_after_third_rent) == 1) {
                                        $this->design->assign('user', $user);
                                        $product = $this->products->get_product(intval($variant->product_id));
                                        $this->design->assign('rentsCount', $usages);
                                        $this->design->assign('product', $product);
                                        $message = $this->design->fetch('email-buy-after-third-rent.tpl');
                                        $this->notify->email('ol@ohmylook.ua', "Напоминание о выкупе", $message, '', 'tk@ohmylook.ua', null, null, 0, true);
                                        $this->notify->email('ys@ohmylook.ua', "Напоминание о выкупе", $message, '', '', null, null, 0, true);
                                    }
                                }
                            }

                            if (!empty($purchase->id)) {
                                if (!empty($variant)) {
                                    $this->orders->update_purchase($purchase->id, array('size_id' => $purchase->size_id, 'start_date' => $purchase->start_date, 'variant_id' => $purchase->variant_id, 'variant_name' => (empty($variant->name) ? '' : $variant->name), 'price' => (empty($purchase->price) ? 0 : $purchase->price), 'amount' => $purchase->amount, 'rent' => (($purchase->rent == '1') ? true : false)));
                                } else {
                                    $this->orders->update_purchase($purchase->id, array('size_id' => $purchase->size_id, 'start_date' => $purchase->start_date, 'price' => (empty($purchase->price) ? 0 : $purchase->price), 'amount' => $purchase->amount, 'rent' => (($purchase->rent == '1') ? true : false)));
                                }
                            } else {
                                $purchase->id = $this->orders->add_purchase(array('size_id' => $purchase->size_id, 'start_date' => $purchase->start_date, 'order_id' => $order->id, 'variant_id' => $purchase->variant_id, 'variant_name' => (empty($variant->name) ? '' : $variant->name), 'price' => (empty($purchase->price) ? 0 : $purchase->price), 'amount' => $purchase->amount, 'rent' => (($purchase->rent == '1') ? true : false)));
                            }
                            $posted_purchases_ids[] = $purchase->id;
                            $posted_variants_ids[] = $purchase->variant_id;
                        }

                        // Удалить непереданные товары
                        $defaultStatuses = $this->variants->getVariantsStatuses(array('is_default' => 1));
                        foreach ($oldPurchases as $p) {
                            if (isset($oldStatus) && ($oldStatus == 1 || $oldStatus == 2)) {
                                // Variant status:
                                if (!in_array($p->variant_id, $posted_variants_ids)) {
                                    if (is_array($defaultStatuses) && count($defaultStatuses) > 0) {
                                        $status = $defaultStatuses[0];
                                        $this->variants->setVariantStatus($p->variant_id, intval($status->id), 0, $order->id);
                                    }
                                }
                            }
                            if (!in_array($p->id, $posted_purchases_ids)) {
                                $this->orders->delete_purchase($p->id);
                            }
                        }

                        if ($new_status == 0) {
                            if (!$this->orders->open(intval($order->id))) {
                                $this->design->assign('message_error', 'error_open');
                            } else {
                                $this->orders->update_order($order->id, array('status' => 0));

                                //Запишем изменение в историю
                                $history_params['order_id'] = $order->id;
                                $history_params['details'] = 'Заказ № ' . $order->id . ' изменил свой статус на НОВЫЙ';
                                $history_id = $this->users->add_to_history($history_params, 0);
                                $this->orders->updateOrderStatus($order->id, 0);
                                if (!$history_id) {
                                    $error = "";
                                }
                                if (isset($oldStatus) && ($oldStatus == 1 || $oldStatus == 2)) {
                                    if (isset($purchases) && is_array($purchases)) {
                                        // Variant status:
                                        $defaultStatuses = $this->variants->getVariantsStatuses(array('is_default' => 1));
                                        if (is_array($defaultStatuses) && count($defaultStatuses) > 0) {
                                            $status = $defaultStatuses[0];
                                            foreach ($purchases as $purchase) {
                                                $this->variants->setVariantStatus($purchase->variant_id, intval($status->id), 0, $order->id);
                                            }
                                        }
                                    }
                                }
                            }
                        } elseif ($new_status == 1) {
                            if (!$this->orders->open(intval($order->id))) {
                                $this->design->assign('message_error', 'error_open');
                            } else {
                                $order->is_trying = 0;
                                $this->orders->update_order($order->id, array('status' => 1));

                                //Запишем изменение в историю
                                $history_params['order_id'] = $order->id;
                                $history_params['details'] = 'Заказ № ' . $order->id . ' изменил свой статус на В РАБОТЕ';
                                $history_id = $this->users->add_to_history($history_params, 0);
                                $this->orders->updateOrderStatus($order->id, 1);
                                if (!$history_id) {
                                    $error = "";
                                }
                                // if (!isset($oldStatus) || $oldStatus != 1) {
                                if (isset($purchases) && is_array($purchases)) {
                                    // Variant status:
                                    $processStatuses = $this->variants->getVariantsStatuses(array('in_process' => 1));
                                    if (is_array($processStatuses) && count($processStatuses) > 0) {
                                        $status = $processStatuses[0];
                                        foreach ($purchases as $purchase) {
                                            $this->variants->setVariantStatus($purchase->variant_id, intval($status->id), intval($purchase->amount), $order->id);
                                        }
                                    }
                                }
                                // }
                                if (!isset($oldStatus) || ($oldStatus != 1)) {
                                    $this->notify->notifyProductsInRent($order->id);
                                }
                            }

                        } elseif ($new_status == 2) {
                            if (!$this->orders->close(intval($order->id))) {
                                $this->design->assign('message_error', 'error_closing');
                            } else {
                                $this->orders->update_order($order->id, array('status' => 2));
                                //Запишем изменение в историю
                                $history_params['order_id'] = $order->id;
                                $history_params['details'] = 'Заказ № ' . $order->id . ' изменил свой статус на ЗАВЕРШЕННЫЙ';
                                $history_id = $this->users->add_to_history($history_params, 0);
                                $this->orders->updateOrderStatus($order->id, 2);
                                $user = $this->users->get_user(intval($order->user_id));

                                /* LOYALTY PROGRAM CHARGE */
                                if (intval($oldStatus) !== 2) {
                                    $this->loyalty->makeTransaction($order);
                                }
                                /* / LOYALTY PROGRAM CHARGE */

                                if ((!isset($oldStatus) || ($oldStatus != 2 && $oldStatus != 5)) && intval($user->affiliate_user) > 0) {
                                    $affiliateUser = $this->users->get_user(intval($user->affiliate_user));
                                    if ($affiliateUser) {
                                        $userOrders = $this->orders->get_orders(array('user_id' => $order->user_id));
                                        if (count($userOrders) == 1) {
                                            $this->bonuses->setUserAdditionalBonuses($user->affiliate_user, $this->settings->bonuses_for_friend_order, 'Ваша подруга оформила заказ.', 4, '', '', 0);
                                        }
                                    }
                                }


                                if (!isset($oldStatus) || ($oldStatus != 2 && $oldStatus != 5)) {
                                    // Group Discount Bonuses
                                    $tmpUser = $this->users->get_user(intval($order->user_id));
                                    $discount = $tmpUser->discount;


                                    // Костыль для распродаж по шоурумам на выбранную дату чтобы не начислять покупателям бонусы
                                    $tempOrder = $this->orders->get_order(intval($order->id));
                                    $orderMadeDate = $tempOrder->date;
                                    $orderMadeCityId = $tempOrder->city_id;
                                    $orderMadeId = $tempOrder->id;

                                    $dateMadeDate = strtotime($orderMadeDate);
                                    $saleStartDate = strtotime('2017-06-09 00:00:00');
                                    $saleEndDate = strtotime('2017-06-11 23:59:59');

                                    $purchase = $this->orders->get_purchases(array('order_id' => $orderMadeId))[0];
                                    $productItem = $this->products->get_product(intval($purchase->product_id));
                                    $brand = $this->brands->get_brand(intval($productItem->brand_id));

                                    if ($orderMadeCityId != 3) {
                                        // default to use without костыль
                                        if ((!$order->discount || intval($order->discount) == 0) || $user->id == 17115) {// Света скайп 16.05.2018 (Не нараховувати дисконтні бонуси якщо в заказі є знижка всім крім одного користувача id = 17115)
                                            if ($discount > 0) {
                                                $updated_order = $this->orders->get_order(intval($order->id));
                                                $discountBonuses = floatval($updated_order->total_price) / 100 * $discount;
                                                if ($order->for_employee != 1) { //Task #3773
                                                    $this->bonuses->setUserAdditionalBonuses(intval($order->user_id), $discountBonuses, 'Дисконт ' . $discount . '%', 6, '', '', 0);
                                                }
                                            }
                                        }
                                        //
                                    } else {

                                        if (($dateMadeDate > $saleStartDate && $dateMadeDate < $saleEndDate) && trim($brand->name) == 'Poustovit') {

                                        } else {
                                            if ((!$order->discount || intval($order->discount) == 0) || $user->id == 17115) {// Света скайп 16.05.2018 (Не нараховувати дисконтні бонуси якщо в заказі є знижка)
                                                if ($discount > 0) {
                                                    $updated_order = $this->orders->get_order(intval($order->id));
                                                    $discountBonuses = floatval($updated_order->total_price) / 100 * $discount;
                                                    if ($order->for_employee != 1) { //Task #3773
                                                        $this->bonuses->setUserAdditionalBonuses(intval($order->user_id), $discountBonuses, 'Дисконт ' . $discount . '%', 6, '', '', 0);
                                                    }
                                                }
                                            }
                                        }

                                    }
                                    // End костыль

                                    if (isset($purchases) && is_array($purchases)) {
                                        // Variant status:
                                        $cleaningStatuses = $this->variants->getVariantsStatuses(array('is_cleaning' => 1));
                                        foreach ($purchases as $purchase) {
                                            // Here bonuses for show rooms:
                                            if (intval($this->settings->enable_showroom_bonuses) == 1) {
                                                $var = $this->variants->get_variant(intval($purchase->variant_id));
                                                if ($var->city_id != $var->showroom_city_id) {
                                                    $this->bonuses->setShowRoomBonuses($var, $purchase->rent, $purchase->amount, $order->id);
                                                }
                                            }
                                            if (intval($purchase->rent) == 1) {
                                                // Variant status:
                                                if (is_array($cleaningStatuses) && count($cleaningStatuses) > 0) {
                                                    $status = $cleaningStatuses[0];
                                                    $this->variants->setVariantStatus($purchase->variant_id, intval($status->id), 1, $order->id);
                                                    // $now = new DateTime();
                                                    // $cleaningDate = DateTime::createFromFormat('Y-m-d', $purchase->start_date);
                                                    // $cleaningDate->add(new DateInterval("P{$purchase->amount}D"))
//                                                    $this->variants->block_variant($purchase->variant_id, $now->format('Y-m-d'), 1, 0, $status->name, true);
                                                }
                                                $this->design->assign('showStatusDialog', 1);
                                            }
                                        }

                                    }
                                }
                                // Количество
                                /* =========== OLD EMAILS BONUSES ============ */
                                /*$userRentsCount = $this->users->getUserRentsCount($order->user_id);
                                if (isset($userRentsCount) && $userRentsCount > 0) {
                                    $newGroupId = 0;
                                    $userTmp = $this->users->get_user(intval($order->user_id));
                                    $userDiscountGroup = $this->users->get_group(intval($userTmp->group_id));
                                    $discountGroupSilver = $this->users->get_group(4);
                                    $discountGroupGold = $this->users->get_group(1);
                                    if ($userRentsCount > 1 && (empty($userDiscountGroup) || intval($userDiscountGroup->discount) < intval($discountGroupSilver->discount))) {
                                        $newGroupId = 4;
                                    }
                                    if ($userRentsCount > 4 && (empty($userDiscountGroup) || intval($userDiscountGroup->discount) < intval($discountGroupGold->discount))){
                                        $newGroupId = 1;
                                    }
                                    if ($newGroupId > 0) {
                                        $newDiscountGroup = $this->users->get_group($newGroupId);
                                        if (!isset($userDiscountGroup->discount) || (intval($userDiscountGroup->discount) < intval($newDiscountGroup->discount))) {
                                            $this->design->assign('discountGroupId', $newGroupId);
                                            $message = $this->design->fetch('email-discount-group.tpl');
                                            $this->notify->email($userTmp->email, "Бонусная система OhMyLook!", $message);
                                            $this->users->update_user(intval($order->user_id), array('group_id' => $newGroupId));
                                        }
                                    }
                                }*/
                                if (!$history_id) {
                                    $error = "";
                                }
                            }
                        } elseif ($new_status == 3) {

                            $oldOrder = $this->orders->get_order($order->id);
                            $oldStatus = intval($oldOrder->status);
                            /* LOYALTY PROGRAM CHARGE */
                            $this->loyalty->deleteTransaction($order);
                            /* / LOYALTY PROGRAM CHARGE */

                            if (!$this->orders->open(intval($order->id))) {
                                $this->design->assign('message_error', 'error_open');
                            } else {
                                $this->orders->update_order($order->id, array('status' => 3));
                                $purchases = $this->orders->get_purchases(array('order_id' => $order->id));
                                foreach ($purchases as $purchase) {
                                    $this->variants->unblock_variant_by_order($purchase->variant_id, $order->id);
                                }
                                //Запишем изменение в историю
                                $history_params['order_id'] = $order->id;
                                $history_params['details'] = 'Заказ № ' . $order->id . ' изменил свой статус на УДАЛЕННЫЕ';
                                $this->orders->updateOrderStatus($order->id, 3);
                                $history_id = $this->users->add_to_history($history_params, 0);
                                if (!$history_id) {
                                    $error = "";
                                }
                                if (isset($oldStatus) && ($oldStatus == 1 || $oldStatus == 2)) {
                                    if (isset($purchases) && is_array($purchases)) {
                                        // Variant status:
                                        $defaultStatuses = $this->variants->getVariantsStatuses(array('is_default' => 1));
                                        if (is_array($defaultStatuses) && count($defaultStatuses) > 0) {
                                            $status = $defaultStatuses[0];
                                            foreach ($purchases as $purchase) {
                                                $this->variants->setVariantStatus($purchase->variant_id, intval($status->id), 0, $order->id);
                                            }
                                        }
                                    }
                                }
                            }
                            if ($order->prepayment > 0) {
                                $this->design->assign('showConvertPaymentsDlg', 1);
                            }
                            if (($bonusesForReturn = $this->bonuses->getBonusesForReturn($user->id, $order->id)) > 0) {
                                $this->bonuses->setUserAdditionalBonuses($user->id, $bonusesForReturn, "возвращены  бонусы, которые использовались для оплаты удаленного заказа #$order->id", 0, $manager, '', 0);
                                $this->design->assign('bonuses_for_return', $bonusesForReturn);
                            }
                            // header('Location: ' . $this->request->get('return'));
                        } elseif ($new_status == 4) {
                            if (!$this->orders->open(intval($order->id))) {
                                $this->design->assign('message_error', 'error_open');
                            } else {
                                $this->orders->update_order($order->id, array('status' => 4));
                                //Запишем изменение в историю
                                $history_params['order_id'] = $order->id;
                                $history_params['details'] = 'Заказ № ' . $order->id . ' изменил свой статус на ЗАБРОНИРОВАН';
                                $this->orders->updateOrderStatus($order->id, 4);
                                $history_id = $this->users->add_to_history($history_params, 0);
                                if (!$history_id) {
                                    $error = "";
                                }
                                if (isset($oldStatus) && ($oldStatus == 1 || $oldStatus == 2)) {
                                    if (isset($purchases) && is_array($purchases)) {
                                        // Variant status:
                                        $defaultStatuses = $this->variants->getVariantsStatuses(array('is_default' => 1));
                                        if (is_array($defaultStatuses) && count($defaultStatuses) > 0) {
                                            $status = $defaultStatuses[0];
                                            foreach ($purchases as $purchase) {
                                                $this->variants->setVariantStatus($purchase->variant_id, intval($status->id), 0, $order->id);
                                            }
                                        }
                                    }
                                }
                            }
                        } elseif ($new_status == 5) {
                            if (!$this->orders->open(intval($order->id))) {
                                $this->design->assign('message_error', 'error_open');
                            } else {
                                $order->is_trying = 1;
                                $this->orders->update_order($order->id, array('status' => 5));
                                //Запишем изменение в историю
                                $history_params['order_id'] = $order->id;
                                $history_params['details'] = 'Заказ № ' . $order->id . ' изменил свой статус на ПРИМЕРКА';
                                $this->orders->updateOrderStatus($order->id, 5);
                                $history_id = $this->users->add_to_history($history_params, 0);
                                if (!$history_id) {
                                    $error = "";
                                }
                                if (isset($oldStatus) && ($oldStatus == 1 || $oldStatus == 2)) {
                                    if (isset($purchases) && is_array($purchases)) {
                                        // Variant status:
                                        $defaultStatuses = $this->variants->getVariantsStatuses(array('is_default' => 1));
                                        if (is_array($defaultStatuses) && count($defaultStatuses) > 0) {
                                            $status = $defaultStatuses[0];
                                            foreach ($purchases as $purchase) {
                                                if (intval($purchase->rent) == 1) {
                                                    $this->variants->setVariantStatus($purchase->variant_id, intval($status->id), 0, $order->id);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        $order = $this->orders->get_order($order->id);

                        // Отправляем письмо пользователю
                        if ($this->request->post('notify_user')) {
                            $this->notify->email_order_user($order->id);
                        }

                        if (isset($oldOrder)) {
                            $newOrder = $order;
                            $newOrder->purchases = $purchases;
                            $order_changes = $this->orders->get_differences_text($oldOrder, $order);
                            if (!empty($order_changes)) {
                                $history_params['order_id'] = $order->id;
                                $history_params['details'] = 'Заказ № ' . $order->id . ' изменен:' . $order_changes;
                                $history_id = $this->users->add_to_history($history_params, 0);
                            }
                        }
                    }
                }
            }
        }
        if (!empty($order) && !empty($order->id) && intval($order->id) > 0) {
            $order = $this->orders->get_order(intval($order->id));
        }

        if (empty($order) || empty($order->id) || intval($order->id) <= 0) {
            $order = new stdClass();
            $order->id = $this->request->get('id', 'integer');
            $order = $this->orders->get_order(intval($order->id));
            if (isset($order) && isset($order->coupon_discount)) {
                $coupon = $order->coupon_discount;
            }
            // Метки заказа
            $order_labels = array();
            if (isset($order->id))
                foreach ($this->orders->get_order_labels($order->id) as $ol) {
                    $order_labels[] = $ol->id;
                }
        }
        if (isset($order) && isset($order->coupon_code) && intval($order->coupon_code) > 0) {
            $currency = $this->money->get_currency();
            $sertificate = $this->coupons->get_coupon(intval($order->coupon_code));
            $sertificate->value = floatval($sertificate->value);
            $sertificate->text = $sertificate->code . ' на ' . $sertificate->value . $currency->sign;
            $this->design->assign('sertificate', $sertificate);
        }

        $purchases_count = 0;
        if ($order && !empty($order->id)) {
            // Покупки
            $products_ids = array();
            $variants_ids = array();
            $variants_sku = array();
            if ($purchases = $this->orders->get_purchases(array('order_id' => $order->id))) {
                foreach ($purchases as $purchase) {
                    $products_ids[] = $purchase->product_id;
                    $variants_ids[] = $purchase->variant_id;
                    $variants_sku[] = $purchase->sku;
                }
            }
            if ($this->request->method('post') && (!empty($saveResult) && $saveResult !== false)) {
                if ((!isset($oldStatus) || ($oldStatus != 2 && $oldStatus != 5)) && $order->status == 2) {//Заказ выполнен
                    $this->bonuses->remove_bonus($order->id);
                    $this->managers->deleteManagersBonusesForOrder($order->id);
                    // todo: remove loyalty bonuses
                }
                $counter = 0;
                $managerBonusTotal = 0;
                foreach ($variants_sku as $sku) {
                    $variant = $this->variants->get_variant_by_sku($sku);
                    $isCashBonus = intval($variant->cash_bonus);
                    if ($user = $this->users->getDressesUser($sku) && intval($variant->purchase_after_third_rent) != 1) {
                        if ((!isset($oldStatus) || ($oldStatus != 2 && $oldStatus != 5)) && $order->status == 2) {//Заказ выполнен
                            if ($purchases[$counter]->rent == '1') {
                                $bonusValue = ($order->for_photoday > 0) ? intval($this->settings->bonus_for_photoday) : intval($variant->bonus_value);
                                if ($bonusValue > 0) {
                                    $bonus = intval($purchases[$counter]->price) * ($bonusValue / 100);
                                    if ($idExisting = $this->bonuses->get_bonus($order->id, $sku)) {
                                        $bonus_arr = array('variant_sku' => $sku, 'order_id' => $order->id, 'bonus_value' => $bonus, 'is_cash' => $isCashBonus);
                                        $this->bonuses->update_bonus($bonus_arr);
                                    } else {
                                        $bonus_arr = array('variant_sku' => $sku, 'order_id' => $order->id, 'bonus_value' => $bonus, 'is_cash' => $isCashBonus);
                                        $this->bonuses->set_bonus($bonus_arr);
                                    }
                                }
                            } elseif ($purchases[$counter]->rent == '0') {
                                $productSold = array('variant_sku' => $sku, 'order_id' => $order->id);
                                $this->bonuses->soldProduct($productSold);
                            }
                        }
                        if ($order->status != 5 && (empty($oldStatus) || $oldStatus != 5)) {
                            if (!empty($accountingRecord) && is_array($accountingRecord) && count($accountingRecord) > 0 && intval($variant->cash_bonus) == 1) {
                                $accountingRecord['has_supplier'] = 1;
                            }
                        }
                    }
                    if ((!isset($oldStatus) || ($oldStatus != 2 && $oldStatus != 5)) && $order->status == 2) {//Заказ выполнен
                        if ($purchases[$counter]->rent == '0') {
                            if (!empty($order->author)) {
                                $diff = max(0, floatval($purchases[$counter]->price) - floatval($variant->sellers_price));
                                $managerBonus = max(0, $diff * (floatval($this->settings->manager_bonus) / 100));
                                $managerBonusTotal += $managerBonus;
                                $this->managers->addManagerBonus(array('manager' => $order->author,
                                    'order_id' => $order->id,
                                    'variant_id' => $variant->id,
                                    'value' => $managerBonus,
                                    'description' => 'Вознаграждение за продажу'
                                ));
                            }
                        }
                    }
                    if (!empty($accountingRecord) && is_array($accountingRecord) && count($accountingRecord) > 0) {
                        if (empty($accountingRecord['variants'])) {
                            $accountingRecord['variants'] = $sku;
                        } else {
                            $accountingRecord['variants'] .= ', ' . $sku;
                        }
                        if ($purchases[$counter]->rent == '1') {
                            $accountingRecord['has_rent'] = 1;
                        } else {
                            $accountingRecord['has_sold'] = 1;
                        }
                    }
                    $counter++;
                }
                // Учет:
                if (!empty($accountingRecord) && is_array($accountingRecord) && count($accountingRecord) > 0) {
                    if ($managerBonusTotal > 0) {
                        $accountingRecord['manager_bonus'] = $managerBonusTotal;
                    }
                    if ($order->payment_method_id == 9 || $order->payment_method_id == 12) {
                        $accountingRecord['source_id'] = 2;
                    } elseif ($order->payment_method_id == 10) {
                        $accountingRecord['source_id'] = 1;
                    } elseif ($order->payment_method_id == 13) {
                        $accountingRecord['source_id'] = 5;
                    }
                    $accountingRecord['order_status_id'] = intval($order->status);
                    $lastAccountingRecord = $this->accounting->getLastOrderDebitRecord($accountingRecord['order_id']);
                    $accountingRecord['payment_type'] = '';
                    if (isset($accountingRecord['has_rent']) && $accountingRecord['has_rent']) {
                        if ($lastAccountingRecord &&
                            isset($lastAccountingRecord->order_status_id) &&
                            intval($lastAccountingRecord->order_status_id) == 4) {
                            $accountingRecord['payment_type'] .= 'Доплата';
                        } elseif ($accountingRecord['order_status_id'] == 4) {
                            $accountingRecord['payment_type'] .= 'Бронь';
                        }  elseif ($accountingRecord['order_status_id'] == 1) {
                            $accountingRecord['payment_type'] .= 'Аренда';
                        } elseif ($accountingRecord['order_status_id'] == 0) {
                            $accountingRecord['payment_type'] .= 'Новый заказ';
                        } else {
                            $accountingRecord['payment_type'] .= 'Доплата';
                        }
                    }
                    if (isset($accountingRecord['has_sold']) && $accountingRecord['has_sold']) {
                        $accountingRecord['payment_type'] .= strlen($accountingRecord['payment_type']) > 0 ? ' / ' : '';
                        $accountingRecord['payment_type'] .= 'День в день';
                    }
                    if (!empty($accountingRecord['manager'])) {
                        if ($tmpManager = $this->managers->get_manager($accountingRecord['manager'])) {
                            $accountingRecord['city_id'] = intval($tmpManager->city) > 0 ? intval($tmpManager->city) : 1;
                        }
                    }
                    $accountingRecord['for_photoday'] = !empty($order->for_photoday) ? $order->for_photoday : 0;
                    $this->accounting->addDebitRecord($accountingRecord);
                    if (floatval($accountingRecord['sum']) > 0) {
                        $this->history->updateUserHistory($order->user_id, 'Заказ #' . $order->id . ', изменение затрат: ');
                        $this->users->addUserCosts($order->user_id, $accountingRecord['sum']);
                    }
                } else {
                    if (!empty($order) && !empty($oldOrder) && $oldOrder->payment_method_id != $order->payment_method_id) {
                        if ($lastAccountingRecord = $this->accounting->getLastOrderDebitRecord($order->id)) {
                            if ($order->payment_method_id == 9 || $order->payment_method_id == 12) {
                                $lastAccountingRecord->source_id = 2;
                            } elseif ($order->payment_method_id == 10) {
                                $lastAccountingRecord->source_id = 1;
                            } elseif ($order->payment_method_id == 13) {
                                $lastAccountingRecord->source_id = 5;
                            }
                            $this->accounting->updateDebitRecord($lastAccountingRecord->id, $lastAccountingRecord);
                        }
                    }
                }
                if ($order->status == 5 || ($order->status == 2 && !empty($oldStatus) && $oldStatus == 5)) {
                    $this->accounting->orderDebitCanHasSupplier($order->id, 0);
                } else {
                    $this->accounting->orderDebitCanHasSupplier($order->id, 1);
                }

                // Update daily debits:
                $paymentsCount = $this->accounting->countDebitRecords(array('order_id' => $order->id, 'include_deleted_orderes' => 1));
                $payments = $this->accounting->getDebitRecords(array('order_id' => $order->id, 'limit' => $paymentsCount, 'include_deleted_orderes' => 1));
                foreach ($payments as $payment) {
                    $this->accounting->updateDateDebit($payment->date, $payment->source_id, $payment->city_id);
                }
            }
            $products = array();
            foreach ($this->products->get_products(array('id' => $products_ids)) as $p) {
                $products[$p->id] = $p;
            }

            $images = $this->products->get_images(array('product_id' => $products_ids));
            foreach ($images as $image) {
                $products[$image->product_id]->images[] = $image;
            }

            $variants = array();
            foreach ($this->variants->get_variants(array('product_id' => $products_ids)) as $v) {
                $variants[$v->id] = $v;
            }
            foreach ($variants as $variant) {
                if (!empty($products[$variant->product_id])) {
                    $products[$variant->product_id]->variants[] = $variant;
                }
            }

            // Check for purchases to birthday:
            $user = $this->users->get_user(intval($order->user_id));
            $userBirthDate = DateTime::createFromFormat('Y-m-d', $user->birth_date);
            if ($userBirthDate !== false) {
                $userBirthDate->setTime(0, 0, 0);
                $this->design->assign('userBirthDate', clone $userBirthDate);
            }
            $forBirthDay = false;
            $subtotal = 0;
            $old_subtotal =0;
            $subtotal_ = 0;
            foreach ($purchases as &$purchase) {
                // Check for purchases to birthday:
                if ($userBirthDate !== false) {
                    if (intval($purchase->rent) == 1) {
                        $purchaseStartRentDate = DateTime::createFromFormat('Y-m-d', $purchase->start_date);
                        if ($purchaseStartRentDate !== false) {
                            $userBirthDate->setDate($purchaseStartRentDate->format('Y'), $userBirthDate->format('m'), $userBirthDate->format('d'));
                            $birthDatePeriodStart = clone $userBirthDate;
                            $birthDatePeriodEnd = clone $userBirthDate;
                            $birthDatePeriodStart->sub(new DateInterval("P2D"));
                            $birthDatePeriodEnd->add(new DateInterval("P2D"));
                            $purchaseStartRentDate->setTime(0, 0, 0);
                            if ($purchaseStartRentDate >= $birthDatePeriodStart && $purchaseStartRentDate <= $birthDatePeriodEnd) {
                                $forBirthDay = true;
                            }
                        }
                    }
                }
                $this->design->assign('forBirthDay', $forBirthDay);

                if (!empty($products[$purchase->product_id])) {
                    $purchase->product = $products[$purchase->product_id];
                }
                if (!empty($variants[$purchase->variant_id])) {
                    $purchase->variant = $variants[$purchase->variant_id];
                }

                //Task #3496
                $purchaseItemOwner = $this->variants->getVariantOwnerBySku($purchase->sku);
                $purchaseItemIsAccessory = $this->variants->isAccessoryBySku($purchase->sku);
                $purchase->isAccessory = $purchaseItemIsAccessory;
                $purchase->ownerId = $purchaseItemOwner->id;

                $amount = $purchase->amount;
                $purchase->real_price = 0;

                if ($purchase->rent == '0') {
                    $subtotal += $purchase->amount * $purchase->price;
                    $purchases_count += $purchase->amount;
                    $purchase->real_price = $purchase->amount * $purchase->price;
                } else {
                    if (intval($order->sub_domain) == 2) {
                        $subtotal += $purchase->price;
                    } else {

                        if (strtotime($order->date) < strtotime(date('13.02.2020'))) {
                            for ($day = 1; $day <= $amount; $day++) {
                                if ($day % 2 == 1) {
                                    //Task #3496
                                    if ($order->for_employee == 1) {
                                        $priceForEmployee = 0;
                                        if ($purchaseItemOwner->id == 17412) {
                                            $priceForEmployee = floatval($purchase->price) * 0.1;
                                        } else {
                                            $priceForEmployee = floatval($purchase->price) * (intval($purchase->variant->bonus_value) / 100);
                                        }

                                        if ($day == 1) {
                                            $subtotal += intval($priceForEmployee);
                                            $purchase->real_price += intval($priceForEmployee);
                                        } elseif ($day == 3) {
                                            $subtotal += intval($priceForEmployee) * 0.5;
                                            $purchase->real_price += intval($priceForEmployee) * 0.5;
                                        } elseif ($day >= 5) {
                                            $subtotal += intval($priceForEmployee) * 0.25;
                                            $purchase->real_price += intval($priceForEmployee) * 0.25;
                                        }
                                        if ($this->request->get('view') == 'print') {
                                            if ($purchaseItemIsAccessory == 1) {
                                                $purchase->real_price += 55;
                                            } else {
                                                $purchase->real_price += 295;
                                            }
                                        }
                                        $purchase->priceForEmployee = $priceForEmployee;
                                    } else {
                                        if ($day == 1) {
                                            $subtotal += intval($purchase->price);
                                            $purchase->real_price += intval($purchase->price);

                                        } elseif ($day == 3) {
                                            $subtotal += intval($purchase->price) * 0.5;
                                            $purchase->real_price += intval($purchase->price) * 0.5;

                                        } elseif ($day >= 5) {
                                            $subtotal += intval($purchase->price) * 0.25;
                                            $purchase->real_price += intval($purchase->price) * 0.25;

                                        }
                                    }
                                }
                            }

//                        //Task #3496
                            /*if ($order->for_employee == 1) {
                                if (!$purchaseItemIsAccessory) {
                                    $subtotal = $subtotal + 100;
                                }
                            }*/
                        } else {
                            for ($day = 1; $day <= $amount; $day++) {
                                //Task #3496
                                if ($order->for_employee == 1) {
                                    $priceForEmployee = 0;
                                    if ($purchaseItemOwner->id == 17412) {
                                        $priceForEmployee = floatval($purchase->price) * 0.1;
                                    } else {
                                        $priceForEmployee = floatval($purchase->price) * (intval($purchase->variant->bonus_value) / 100);
                                    }

                                    if ($day == 1) {
                                        $subtotal_ = intval($priceForEmployee);
                                        $purchase->real_price = intval($priceForEmployee);
                                    } elseif ($day == 4) {
                                        $old_subtotal_ = 0.15 * ($day - 3) * intval($priceForEmployee);
                                        $subtotal_ = $subtotal_+ $old_subtotal;
                                        $purchase->real_price = $subtotal_;
                                    } elseif ($day == 5) {
                                        $subtotal_ = $subtotal_+ $old_subtotal;
                                        $purchase->real_price = $subtotal_;
                                    } elseif ($day == 6) {
                                        $subtotal_ = $subtotal_+ $old_subtotal;
                                        $purchase->real_price = $subtotal_;
                                    } elseif ($day == 7) {
                                        $old_subtotal = 0.1 * ($day - 6) * intval($priceForEmployee);
                                        $subtotal_ = $subtotal_+ $old_subtotal;
                                        $purchase->real_price = $subtotal_;
                                    } elseif ($day == 8) {
                                        $subtotal_ = $subtotal_+ $old_subtotal;
                                        $purchase->real_price = $subtotal_;
                                    }  elseif ($day == 9) {
                                        $subtotal_ = $subtotal_+ $old_subtotal;
                                        $purchase->real_price = $subtotal_;
                                    }  elseif ($day == 10) {
                                        $subtotal_ = $subtotal_+ $old_subtotal;
                                        $purchase->real_price = $subtotal_;
                                    }  elseif ($day >= 11) {
                                        $old_subtotal = 0.05 * ($day - 10) * intval($priceForEmployee);
                                        $subtotal_ = $subtotal_+ $old_subtotal;
                                        $purchase->real_price = $subtotal_;
                                    }
                                    if ($this->request->get('view') == 'print') {
                                        if ($purchaseItemIsAccessory == 1) {
                                            $purchase->real_price += 55;
                                        } else {
                                            $purchase->real_price += 295;
                                        }
                                    }
                                    $purchase->priceForEmployee = $priceForEmployee;
                                } else {
                                    //$purchase->price
                                    if ($day == 1) {
                                        $subtotal_ = intval($purchase->price);
                                        $purchase->real_price = intval($purchase->price);
                                    } elseif ($day == 4) {
                                        $old_subtotal = 0.15 * ($day - 3) * intval($purchase->price);
                                        $subtotal_ = $subtotal_+ $old_subtotal;
                                        $purchase->real_price = $subtotal_;
                                    } elseif ($day == 5) {
                                        $subtotal_ = $subtotal_+ $old_subtotal;
                                        $purchase->real_price = $subtotal_;
                                    } elseif ($day == 6) {
                                        $subtotal_ = $subtotal_+ $old_subtotal;
                                        $purchase->real_price = $subtotal_;
                                    } elseif ($day == 7) {
                                        $old_subtotal = 0.1 * ($day - 6) * intval($purchase->price);
                                        $subtotal_ = $subtotal_+ $old_subtotal;
                                        $purchase->real_price = $subtotal_;
                                    } elseif ($day == 8) {
                                        $subtotal_ = $subtotal_+ $old_subtotal;
                                        $purchase->real_price = $subtotal_;
                                    }  elseif ($day == 9) {
                                        $subtotal_ = $subtotal_+ $old_subtotal;
                                        $purchase->real_price = $subtotal_;
                                    }  elseif ($day == 10) {
                                        $subtotal_ = $subtotal_+ $old_subtotal;
                                        $purchase->real_price = $subtotal_;
                                    }  elseif ($day >= 11) {
                                        $old_subtotal = 0.05 * ($day - 10) * intval($purchase->price);
                                        $subtotal_ = $subtotal_+ $old_subtotal;
                                        $purchase->real_price = $subtotal_;
                                    }
                                }
                            }

                        }

//                        //Task #3496
                        /*if ($order->for_employee == 1) {
                            if (!$purchaseItemIsAccessory) {
                                $subtotal = $subtotal + 100;
                            }
                        }*/
                    }
                    $purchases_count += 1;
                }
                $subtotal +=$subtotal_;
            }


            // todo: loyalty

            $this->orders->update_order($order->id, array('full_price' => $subtotal));

        } else {
            $purchases = array();
        }

        if (empty($order)) {
            $user_id = $this->request->get('user_id');
            if ($this->request->get('subscription')){
                $order->subscription_id = $this->request->get('subscription');
            }
            if (!empty($user_id)) {
                $user = $this->users->get_user((int)$user_id);
                if ($user) {
                    $order->user_id = $user->id;
                    $order->name = $user->name;
                    $order->phone = $user->phone;
                    $order->email = $user->email;
                    // Пользователь
                    $this->design->assign('user', $user);

                    $totalBonuses = $this->bonuses->getUserBonusesTotal($user_id);
                    $this->design->assign('total_bonuses', $totalBonuses);
                }
            }
            $subscriptionId = $this->request->get('subscription');
            if (!empty($subscriptionId)) {
                    $this->design->assign('subscriptionId', $subscriptionId);
            } else {
                $this->design->assign('subscriptionId', '');
            }
        }
        if (isset($order) && $order) {
            if ($coupon > $subtotal) {
                $order->coupon_discount = $subtotal;
            } else {
                $order->coupon_discount = $coupon;
            }
        }
////        $insuranceVal=0;
//        if( $order->insurance_check ==1){
//            $insuranceVal+=floatval(0.1*$subtotal);
//            $order->insurance=$insuranceVal;
//            $subtotal +=$insuranceVal;
//        }

        //Щитаем доступные бонусы:
        if (isset($order) && isset($order->id)) {
            $userID = $order->user_id;
            if ($userID) {
                $totalBonuses = $this->bonuses->getUserBonusesTotal($userID);
                $this->design->assign('total_bonuses', $totalBonuses + $order->coupon_discount);

                if ($lpBonuses === null) {
                    $lpBonuses = (float)$this->loyalty->getClientBonuses($user);
                    $this->design->assign('total_loyalty_bonuses', $lpBonuses);
                }
            }


//            $subtotal = $order->total_price + $order->insurance;
        }

        $this->design->assign('total_loyalty_bonuses', $lpBonuses);

        $this->design->assign('purchases', $purchases);
        $this->design->assign('purchases_count', $purchases_count);
        // todo: check dafuq is happening (this var makes no sense on front)
        $this->design->assign('subtotal', $subtotal);

        // $this->orders->update_order($order->id, array('full_price' => $subtotal));

        if ($this->request->get('view') == 'print_receipt') {
            /*if ($order->for_employee == 1) {
                if ($purchaseItemIsAccessory == 1) {
                    $stylesPrice = 55;
                } else {
                    $stylesPrice = 95;
                }
                $order->total_price += $stylesPrice;
                $order->char_sum = $this->orders->num2str(($order->total_price));
            } else {
                $order->char_sum = $this->orders->num2str(($order->total_price));
            }*/
            $order->char_sum = $this->orders->num2str($order->total_price);

            //$showroom
            if (isset($order) && isset($order->id)) {
                if (!empty($order->id) && intval($order->id) > 0) {
                    $cityId = intval($order->city_id);
                    $showroom = $this->cities->getCity($cityId);
                    $this->design->assign('showroom', $showroom);
                }
            }
        }

        $this->design->assign('order', $order);

        if (isset($order) && isset($order->id)) {
            // User stickers
            $userStickersCount = $this->tracker->countStickers(array('user_id' => intval($order->user_id)));
            $this->design->assign('userStickersCount', $userStickersCount);
            // User incoming calls:
            $userCallsCount = $this->callCenter->countUserAllCalls(array('user_id' => intval($order->user_id), 'incoming_calls' => 1, 'outgoing_calls' => 1));
            $this->design->assign('userCallsCount', $userCallsCount);

            // Способ доставки
            if (isset($order->delivery_id)) {
                $delivery = $this->delivery->get_delivery($order->delivery_id);
                $this->design->assign('delivery', $delivery);
            }

            // Способ оплаты
            if (isset($order->payment_method_id)) {
                $payment_method = $this->payment->get_payment_method($order->payment_method_id);
            }

            if (!empty($payment_method)) {
                $this->design->assign('payment_method', $payment_method);

                // Валюта оплаты
                $payment_currency = $this->money->get_currency(intval($payment_method->currency_id));
                $this->design->assign('payment_currency', $payment_currency);
            }
            // источник
//            if(isset($order->how_know)){
//                $how_know= $this->howKnow->get_how_know(intval($order->how_know));
//                if(!empty($how_know)) {
//                    $this->design->assign('how_know', $how_know);
//                }
//            }

            // Повод
            if (isset($order->rent_reason)) {
                $rent_reason = $this->reason->get_rent_reason(intval($order->rent_reason));
                if (!empty($rent_reason)) {
                    $this->design->assign('rent_reason', $rent_reason);
                }
            }

            // Пользователь
            if (isset($order->user_id) && $order->user_id) {
                $this->design->assign('user', $this->users->get_user(intval($order->user_id)));
            }

            // Соседние заказы
            if (isset($order) && isset($order->id)) {
                $this->design->assign('next_order', $this->orders->get_next_order($order->id, $this->request->get('status', 'string')));
                $this->design->assign('prev_order', $this->orders->get_prev_order($order->id, $this->request->get('status', 'string')));
            }
            $defaultValues = false;
        } else {
            $defaultValues = true;
        }
        $this->design->assign('defaultValues', $defaultValues);

        if (isset($order) && isset($order->id)) {
            $requireTransportation = $this->orders->isOrderRequiredTransportation($order->id);
            if ($requireTransportation) {
                $this->design->assign('message_info', 'require_transportation');
            }
        }

        $managers = $this->managers->get_managers();
        sort($managers);
        $current_manager = $this->managers->get_manager();
        $this->design->assign('managers', $managers);
        $this->design->assign('current_manager', $current_manager);

        if($order->user_id) {
            $subscriptions = $this->users->getUserSubscribtionsForOrders($order->user_id);
            sort($subscriptions);
            $current_subscription = $order->subscription_id;
            $this->design->assign('subscriptions', $subscriptions);
            $this->design->assign('current_subscription', $current_subscription);
        }

        if (isset($order) && isset($order->id)) {
            // История заказа
            $order_history = $this->users->check_manager_from_site($order->id);
            if (isset($order_history)) {
                if (isset($order_history->from_site)) {
                    $this->design->assign('from_site', $order_history->from_site);
                }
                if (isset($order_history->user)) {
                    $this->design->assign('history_user', $order_history->user);
                }
            }

            // Accounting payments:
            // $debitSourcesCount = $this->accounting->countDebitSources();
            // $debitSources = $this->accounting->getDebitSources(array('limit' => $debitSourcesCount));
            // $this->design->assign('debitSources', $debitSources);
            if (!empty($order->id) && intval($order->id) > 0) {
                $paymentsCount = $this->accounting->countDebitRecords(array('order_id' => $order->id));
                $payments = $this->accounting->getDebitRecords(array('order_id' => $order->id, 'limit' => $paymentsCount));
                $this->design->assign('payments', $payments);
            }
        }

        // loyalty program (bonuses)
        $lpBonuses = (float)$this->loyalty->getClientBonuses($user);
        $this->design->assign('total_loyalty_bonuses', $lpBonuses);


        // Все способы доставки
        $deliveries = $this->delivery->get_deliveries();
        $this->design->assign('deliveries', $deliveries);

        // Все способы оплаты
        $payment_methods = $this->payment->get_payment_methods();
        $this->design->assign('payment_methods', $payment_methods);


        // Все поводы
        $rent_reasons = $this->reason->get_rent_reasons();
        $this->design->assign('rent_reasons', $rent_reasons);


        // Все источники
        $how_knows = $this->howKnow->get_how_knows();
        $this->design->assign('how_knows', $how_knows);


        // Метки заказов
        $labels = $this->orders->get_labels();
        $this->design->assign('labels', $labels);

        $this->design->assign('order_labels', $order_labels);

        // Determine active tab of main menu:
        $this->design->assign('activeTab', 'orders');

        //результаты опроса качества работы сервиса
        $serviceQuality = $this->feedbacks->getOverallServiceQualityAnsqer($order->user_id, $order->id);
        $this->design->assign('serviceQuality', $serviceQuality);

        if ($this->request->get('view') == 'print') {
            if ($order->loyalty_discount > 0) {
                $order->full_price -= $order->loyalty_discount;
            }
            if ($order->for_employee == 1) {
                $order->full_price += array_reduce($purchases, function($total, $purchase) {
                    return $total + ($purchase->rent == '1' ? ($purchase->isAccessory == 1 ? 55 : 295) : 0);
                }, 0);
                $order->char_sum = $this->orders->num2str($order->full_price);
            } else {
                $order->char_sum = $this->orders->num2str($order->full_price);
            }
//            $order->char_sum = $this->orders->num2str($order->full_price);

            return $this->design->fetch('order_print.tpl');
        } elseif ($this->request->get('view') == 'print_receipt') {
            return $this->design->fetch('order_print_receipt.tpl');
        } else {
            return $this->design->fetch('order-subscription.tpl');
        }
    }

    public function calculatePurchaseSubtotal($order)
    {
        $purchases_count = 0;
        $subtotal = 0;
        $old_subtotal =0;
        $purchases = $this->orders->get_purchases(array('order_id' => $order->id));
        foreach ($purchases as &$purchase) {
            $purchase->real_price = 0;
            $amount = $purchase->amount;
            $purchaseItemOwner = $this->variants->getVariantOwnerBySku($purchase->sku);
            $purchaseItemIsAccessory = $this->variants->isAccessoryBySku($purchase->sku);
            if ($purchase->rent == '0') {

                $subtotal += $purchase->amount * $purchase->price;
                $purchases_count += $purchase->amount;
                $purchase->real_price = $purchase->amount * $purchase->price;
            } else {
                if (intval($order->sub_domain) == 2) {
                    $subtotal += $purchase->price;
                } else {
                    if (strtotime($order->date) < strtotime(date('13.02.2020'))) {
                        for ($day = 1; $day <= $amount; $day++) {
                            if ($day % 2 == 1) {
                                //Task #3496
                                if ($order->for_employee == 1) {
                                    $priceForEmployee = 0;
                                    if ($purchaseItemOwner->id == 17412) {
                                        $priceForEmployee = floatval($purchase->price) * 0.1;
                                    } else {
                                        $priceForEmployee = floatval($purchase->price) * (intval($purchase->variant->bonus_value) / 100);
                                    }

                                    if ($day == 1) {
                                        $subtotal += intval($priceForEmployee);
                                        $purchase->real_price += intval($priceForEmployee);
                                    } elseif ($day == 3) {
                                        $subtotal += intval($priceForEmployee) * 0.5;
                                        $purchase->real_price += intval($priceForEmployee) * 0.5;
                                    } elseif ($day >= 5) {
                                        $subtotal += intval($priceForEmployee) * 0.25;
                                        $purchase->real_price += intval($priceForEmployee) * 0.25;
                                    }
                                    $purchase->priceForEmployee = $priceForEmployee;
                                } else {
                                    if ($day == 1) {
                                        $subtotal += intval($purchase->price);
                                        $purchase->real_price += intval($purchase->price);
                                    } elseif ($day == 3) {
                                        $subtotal += intval($purchase->price) * 0.5;
                                        $purchase->real_price += intval($purchase->price) * 0.5;
                                    } elseif ($day >= 5) {
                                        $subtotal += intval($purchase->price) * 0.25;
                                        $purchase->real_price += intval($purchase->price) * 0.25;
                                    }
                                }
                            }
                        }
                    } else {//new formula
                        for ($day = 1; $day <= $amount; $day++) {
                            //Task #3496
                            if ($order->for_employee == 1) {
                                $priceForEmployee = 0;
                                if ($purchaseItemOwner->id == 17412) {
                                    $priceForEmployee = floatval($purchase->price) * 0.1;
                                } else {
                                    $priceForEmployee = floatval($purchase->price) * (intval($purchase->variant->bonus_value) / 100);
                                }

                                if ($day == 1) {
                                    $subtotal = intval($priceForEmployee);
                                    $purchase->real_price = intval($priceForEmployee);
                                } elseif ($day == 4) {
                                    $old_subtotal = 0.15 * ($day - 3) * intval($priceForEmployee);
                                    $subtotal = $subtotal+ $old_subtotal;
                                    $purchase->real_price = $subtotal;
                                } elseif ($day == 5) {
                                    $subtotal = $subtotal+ $old_subtotal;
                                    $purchase->real_price = $subtotal;
                                } elseif ($day == 6) {
                                    $subtotal = $subtotal+ $old_subtotal;
                                    $purchase->real_price = $subtotal;
                                } elseif ($day == 7) {
                                    $old_subtotal = 0.1 * ($day - 6) * intval($priceForEmployee);
                                    $subtotal = $subtotal+ $old_subtotal;
                                    $purchase->real_price = $subtotal;
                                } elseif ($day == 8) {
                                    $subtotal = $subtotal+ $old_subtotal;
                                    $purchase->real_price = $subtotal;
                                }  elseif ($day == 9) {
                                    $subtotal = $subtotal+ $old_subtotal;
                                    $purchase->real_price = $subtotal;
                                }  elseif ($day == 10) {
                                    $subtotal = $subtotal+ $old_subtotal;
                                    $purchase->real_price = $subtotal;
                                }  elseif ($day >= 11) {
                                    $old_subtotal = 0.05 * ($day - 10) * intval($priceForEmployee);
                                    $subtotal = $subtotal+ $old_subtotal;
                                    $purchase->real_price = $subtotal;
                                }
                                if ($this->request->get('view') == 'print') {
                                    if ($purchaseItemIsAccessory == 1) {
                                        $purchase->real_price += 55;
                                    } else {
                                        $purchase->real_price += 295;
                                    }
                                }
                                $purchase->priceForEmployee = $priceForEmployee;
                            } else {
                                //$purchase->price
                                if ($day == 1) {
                                    $subtotal = intval($purchase->price);
                                    $purchase->real_price = intval($purchase->price);
                                } elseif ($day == 4) {
                                    $old_subtotal = 0.15 * ($day - 3) * intval($purchase->price);
                                    $subtotal = $subtotal+ $old_subtotal;
                                    $purchase->real_price = $subtotal;
                                } elseif ($day == 5) {
                                    $subtotal = $subtotal+ $old_subtotal;
                                    $purchase->real_price = $subtotal;
                                } elseif ($day == 6) {
                                    $subtotal = $subtotal+ $old_subtotal;
                                    $purchase->real_price = $subtotal;
                                } elseif ($day == 7) {
                                    $old_subtotal = 0.1 * ($day - 6) * intval($purchase->price);
                                    $subtotal = $subtotal+ $old_subtotal;
                                    $purchase->real_price = $subtotal;
                                } elseif ($day == 8) {
                                    $subtotal = $subtotal+ $old_subtotal;
                                    $purchase->real_price = $subtotal;
                                }  elseif ($day == 9) {
                                    $subtotal = $subtotal+ $old_subtotal;
                                    $purchase->real_price = $subtotal;
                                }  elseif ($day == 10) {
                                    $subtotal = $subtotal+ $old_subtotal;
                                    $purchase->real_price = $subtotal;
                                }  elseif ($day >= 11) {
                                    $old_subtotal = 0.05 * ($day - 10) * intval($purchase->price);
                                    $subtotal = $subtotal+ $old_subtotal;
                                    $purchase->real_price = $subtotal;
                                }
                            }
                        }

                    }
//                        //Task #3496
                    if ($order->for_employee == 1) {
                        if (!$purchaseItemIsAccessory) {
                            $subtotal = $subtotal + 100;
                        }
                    }
                }
                $purchases_count += 1;

                //       $this->orders->update_order($order->id, array('full_price' => $subtotal));

            }
        }

        return $subtotal;
    }

    private function getPurchasesCount($userId, $orderId, $dateFrom, $dateTo)
    {
        $sql = $this->db->placehold("
        SELECT SUM(purchases_sum) AS p_sum
        FROM
          (SELECT
             (SELECT SUM(p.amount)
              FROM s_purchases_ohmylook p
              JOIN s_products pr ON p.product_id = pr.id
              WHERE p.order_id = o.id AND p.rent = 1 AND pr.parent_category_id = 7) AS purchases_sum
           FROM s_orders o
           WHERE o.user_id = ?
             AND o.`status` = 2
             AND o.`date` BETWEEN ? AND ?) AS purchases_count
        ", intval($userId), $dateFrom, $dateTo);

        $sql2 = $this->db->placehold("
        SELECT SUM(purchases_sum) AS p_sum
        FROM
          (SELECT
             (SELECT SUM(p.amount)
              FROM s_purchases_ohmylook p
              JOIN s_products pr ON p.product_id = pr.id
              WHERE p.order_id = o.id AND p.rent = 1 AND pr.parent_category_id = 7) AS purchases_sum
           FROM s_orders o
           WHERE o.id = ?
             AND o.`date` BETWEEN ? AND ?) AS purchases_count
        ", intval($orderId), $dateFrom, $dateTo);

        $res1 = $this->db->query($sql)->fetch_object()->p_sum;
        $res2 = $this->db->query($sql2)->fetch_object()->p_sum;

        $purchasesCount = intval($res1) + intval($res2);

        return $purchasesCount;
    }

    private function dressAsGiftMessageData($purchasesCount)
    {
        $rentLimit = 4;

        if (!$purchasesCount || $purchasesCount > $rentLimit) {
            return false;
        }

        $messageData = new \stdClass();
        $messageData->subject = 'Ура! Еще чуть-чуть и ты получишь аренду платья в подарок';
        $messageData->sender = 'Oh My Look!';

        if ($purchasesCount && $purchasesCount < $rentLimit) {
            $purchasesLeft = $rentLimit - $purchasesCount;
            $rentText = $purchasesLeft == 1 ? 'аренду' : 'аренды';
            $messageData->message = "У нас для тебя классная новость! До 31 августа каждая пятая аренда - в подарок! Соверши еще {$purchasesLeft} {$rentText} платья в Oh My Look! и получи аренду любого платья абсолютно бесплатно!*";
        }
        else if($purchasesCount && $purchasesCount > $rentLimit) {
            $messageData->message = 'Поздравляем! Твоя следующая аренда платья в Oh My Look! - бесплатно!';
        }
        $messageData->message .= "<br/>*бесплатная аренда на двое суток<br/>Подробности на сайте <a href='https://ohmylook.ua'>ohmylook.ua</a>";

        return $messageData;
    }
}

