<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class lotto extends Model
{
    use HasFactory;

    protected $fillable = [
        'drwNo',
        'drwNoDate',
        'totSellamnt',
        'firstWinamnt',
        'firstPrzwnerCo',
        'firstAccumamnt',
        'description',
        'drwNo1',
        'drwNo2',
        'drwNo3',
        'drwNo4',
        'drwNo5',
        'drwNo6',
        'bnusNo',
    ];

}
