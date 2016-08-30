<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Document extends Model
{
    protected $fillable = [
        'name', 'data_preview', 'data', 'user_id',
    ];

    public $timestamps = false;
}
