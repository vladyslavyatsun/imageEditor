<?php

use Illuminate\Http\Request;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::post('/register', 'Auth\RegisterController@register');
Route::post('/login', 'Auth\LoginController@login');

Route::get('/documents', 'DocumentsController@index');
Route::post('/documents', 'DocumentsController@store');
Route::get('/documents/{id}/preview', 'DocumentsController@showPreview');
Route::get('/documents/{id}/name', 'DocumentsController@showName');
Route::get('/documents/{id}/document', 'DocumentsController@showDocument');
Route::delete('/documents/{id}', 'DocumentsController@destroy');
