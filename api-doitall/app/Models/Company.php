<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Company extends Model
{
    use HasFactory;


    protected $fillable = [
        'name', 'cnpj', 'address', 'city', 'uf', 'phone',  'user_id',
        'opendate', 'lastupdate', 'complement', 'type', 'fantasyname', 'neiborhood',
        'socialcapital', 'status', 'size', 'addressnumber', 'jurisnature',
        'email', 'user_id', 'cep'];
        
        protected $casts = [
            'employers' => 'json',
        ];

        public function addEmployer($employer)
        {
            $employers = json_decode($this->employers, true);
            $employers[] = $employer;
            $this->employers = json_encode($employers);
            $this->save();
        }
}

